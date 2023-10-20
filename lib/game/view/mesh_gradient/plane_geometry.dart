import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

Offset Function(int, int) _multiMix({
  required int tesselation,
  required Offset topLeftVertex,
  required Offset topRightVertex,
  required Offset bottomLeftVertex,
  required Offset bottomRightVertex,
  required double cpdX,
  required double cpdY,
}) =>
    (int innerRow, int innerCol) {
      final x = innerRow / tesselation;
      final y = innerCol / tesselation;

      final tx = deCasteljauInterpolation(
        point1: topLeftVertex,
        point2: topRightVertex,
        controlPoint1: topLeftVertex + Offset(cpdX, 0),
        controlPoint2: topRightVertex + Offset(-cpdX, 0),
        progressAlongLine: x,
      );

      final bx = deCasteljauInterpolation(
        point1: bottomLeftVertex,
        point2: bottomRightVertex,
        controlPoint1: bottomLeftVertex + Offset(cpdX, 0),
        controlPoint2: bottomRightVertex + Offset(-cpdX, 0),
        progressAlongLine: x,
      );

      return deCasteljauInterpolation(
        point1: tx,
        point2: bx,
        controlPoint1: tx + Offset(0, cpdY),
        controlPoint2: bx + Offset(0, -cpdY),
        progressAlongLine: y,
      );
    };

class PlaneGeometry {
  PlaneGeometry({
    required this.xSegments,
    required this.ySegments,
  });

  final int xSegments;
  final int ySegments;

  (ui.Vertices, List<Offset>) getVertices(
    Size size,
    List<Offset> vertices,
    List<Offset> ogVertices, [
    int tesselation = 12,
    double cubicControlpointFactorX = 0.3,
    double cubicControlpointFactorY = 0.3,
  ]) {
    final verticesTriangles = List<Offset>.filled(
      (xSegments * ySegments) * 6 * tesselation * tesselation * 2,
      Offset.zero,
    );
    final ogVerticesTriangles = List<Offset>.filled(
      (xSegments * ySegments) * 6 * tesselation * tesselation * 2,
      Offset.zero,
    );

    final xStep = size.width / xSegments;
    final yStep = size.height / ySegments;
    final itemsPerRow = xSegments + 1;

    var count = -1;

    void addVertex(Offset vertex, Offset ogVertex) {
      verticesTriangles[++count] = vertex;
      ogVerticesTriangles[count] = ogVertex;
    }

    for (var trow = 0; trow < (ySegments * tesselation); trow++) {
      for (var tcol = 0; tcol < (xSegments * tesselation); tcol++) {
        final row = trow ~/ tesselation;
        final col = tcol ~/ tesselation;

        final topLeftVertex =
            vertices.getWithinSize(row * itemsPerRow + col, size);
        final topLeftOgVertex =
            ogVertices.getWithinSize(row * itemsPerRow + col, size);

        final topRightVertex =
            vertices.getWithinSize(row * itemsPerRow + col + 1, size);
        final topRightOgVertex =
            ogVertices.getWithinSize(row * itemsPerRow + col + 1, size);

        final bottomLeftVertex =
            vertices.getWithinSize((row + 1) * itemsPerRow + col, size);
        final bottomLeftOgVertex =
            ogVertices.getWithinSize((row + 1) * itemsPerRow + col, size);

        final bottomRightVertex =
            vertices.getWithinSize((row + 1) * itemsPerRow + col + 1, size);
        final bottomRightOgVertex =
            ogVertices.getWithinSize((row + 1) * itemsPerRow + col + 1, size);

        final innerRow = trow % tesselation;
        final innerCol = tcol % tesselation;

        final controlPointDisplacementX = xStep * cubicControlpointFactorX;

        final controlPointDisplacementY = yStep * cubicControlpointFactorY;

        final multiMixDistorted = _multiMix(
          tesselation: tesselation,
          topLeftVertex: topLeftVertex,
          topRightVertex: topRightVertex,
          bottomLeftVertex: bottomLeftVertex,
          bottomRightVertex: bottomRightVertex,
          cpdX: controlPointDisplacementX,
          cpdY: controlPointDisplacementY,
        );

        final topLeft = multiMixDistorted(innerRow, innerCol);
        final topRight = multiMixDistorted(innerRow, innerCol + 1);
        final bottomLeft = multiMixDistorted(innerRow + 1, innerCol);
        final bottomRight = multiMixDistorted(innerRow + 1, innerCol + 1);

        final multiMixOg = _multiMix(
          tesselation: tesselation,
          topLeftVertex: topLeftOgVertex,
          topRightVertex: topRightOgVertex,
          bottomLeftVertex: bottomLeftOgVertex,
          bottomRightVertex: bottomRightOgVertex,
          cpdX: controlPointDisplacementX,
          cpdY: controlPointDisplacementY,
        );

        final topLeftOg = multiMixOg(innerRow, innerCol);
        final topRightOg = multiMixOg(innerRow, innerCol + 1);
        final bottomLeftOg = multiMixOg(innerRow + 1, innerCol);
        final bottomRightOg = multiMixOg(innerRow + 1, innerCol + 1);

        addVertex(topLeft, topLeftOg);
        addVertex(topRight, topRightOg);
        addVertex(bottomRight, bottomRightOg);
        addVertex(topLeft, topLeftOg);
        addVertex(bottomLeft, bottomLeftOg);
        addVertex(bottomRight, bottomRightOg);
      }
    }

    return (
      ui.Vertices(
        ui.VertexMode.triangles,
        verticesTriangles,
        textureCoordinates: ogVerticesTriangles,
      ),
      verticesTriangles,
    );
  }
}

List<Offset> trianglesFrom(
  Offset topLeft,
  Offset topRight,
  Offset bottomLeft,
  Offset bottomRight,
) {
  return [topLeft, topRight, bottomRight, topLeft, bottomLeft, bottomRight];
}

extension on Offset {
  Offset withinSize(Size size) {
    return Offset(
      dx * size.width,
      dy * size.height,
    );
  }
}

/// Thanks to this french man
Offset deCasteljauInterpolation({
  required Offset point1,
  required Offset point2,
  required Offset controlPoint1,
  required Offset controlPoint2,
  required double progressAlongLine,
}) {
  final t = progressAlongLine;

  final l = point1 * (1 - t) + controlPoint1 * t;
  final m = controlPoint1 * (1 - t) + controlPoint2 * t;
  final n = controlPoint2 * (1 - t) + point2 * t;

  final p = l * (1 - t) + m * t;
  final q = m * (1 - t) + n * t;

  final r = p * (1 - t) + q * t;

  return r;
}

Map<int, Offset?> _vectorWithinSizeCache = {};

extension on List<Offset> {
  Offset getWithinSize(
    int index,
    Size size,
  ) {
    if (_vectorWithinSizeCache.isNotEmpty &&
        _vectorWithinSizeCache[-1] != Offset(size.width, size.height)) {
      _vectorWithinSizeCache.clear();
    }

    final cached = _vectorWithinSizeCache[index];
    if (cached == null) {
      return _vectorWithinSizeCache[index] = this[index].withinSize(size);
    }
    return cached;
  }
}
