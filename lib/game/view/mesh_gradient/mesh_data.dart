import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crystal_ball/game/view/mesh_gradient/mesh_data_hash.dart';
import 'package:flutter/material.dart';

@immutable
class Mesh25Data {
  const Mesh25Data({
    required this.vertices,
    required this.selectedColors,
    required this.quadColorLerper,
    required this.tessellation,
    required this.cubicControlPointFactorX,
    required this.cubicControlPointFactorY,
  });

  factory Mesh25Data.initialize({
    required Color colorTopLeft,
    required Color colorTopRight,
    required Color colorBottomLeft,
    required Color colorBottomRight,
    required int tessellation,
    required double cubicControlpointFactorX,
    required double cubicControlpointFactorY,
    Map<int, Color>? selectedColors,
  }) {
    final colorLerper = QuadColorLerper25(
      colorTopLeft: colorTopLeft,
      colorTopRight: colorTopRight,
      colorBottomLeft: colorBottomLeft,
      colorBottomRight: colorBottomRight,
    );

    return Mesh25Data(
      vertices: initialVertices,
      selectedColors: selectedColors ?? {},
      quadColorLerper: colorLerper,
      tessellation: tessellation,
      cubicControlPointFactorX: cubicControlpointFactorX,
      cubicControlPointFactorY: cubicControlpointFactorY,
    );
  }

  factory Mesh25Data.lerp(Mesh25Data a, Mesh25Data b, double t) {
    if (t <= 0.0) {
      return a;
    }

    if (t >= 1.0) {
      return b;
    }

    return Mesh25Data(
      vertices: <Offset>[
        for (int i = 0; i < a.vertices.length; i++)
          Offset.lerp(a.vertices[i], b.vertices[i], t)!,
      ],
      selectedColors: <int, Color>{
        for (int i = 0; i < a.vertices.length; i++)
          if (a.selectedColors[i] != null && b.selectedColors[i] != null)
            i: Color.lerp(a.selectedColors[i], b.selectedColors[i], t)!
          else if (a.selectedColors[i] != null)
            i: Color.lerp(a.selectedColors[i], b.colors[i], t)!
          else if (b.selectedColors[i] != null)
            i: Color.lerp(a.colors[i], b.selectedColors[i], t)!,
      },
      quadColorLerper: QuadColorLerper25.lerp(
        a.quadColorLerper,
        b.quadColorLerper,
        t,
      ),
      tessellation: b.tessellation,
      cubicControlPointFactorX: ui.lerpDouble(
        a.cubicControlPointFactorX,
        b.cubicControlPointFactorX,
        t,
      )!,
      cubicControlPointFactorY: ui.lerpDouble(
        a.cubicControlPointFactorY,
        b.cubicControlPointFactorY,
        t,
      )!,
    );
  }

  factory Mesh25Data.fromHash(String hash) {
    return getAMesh25FromHash(hash);
  }

  static List<Offset> get initialVertices {
    return Iterable.generate(25, (index) {
      final x = index % 5 / 4;
      final y = index ~/ 5 / 4;
      return Offset(x, y);
    }).toList();
  }

  final List<Offset> vertices;

  final QuadColorLerper25 quadColorLerper;

  final Map<int, Color> selectedColors;

  final int tessellation;

  final double cubicControlPointFactorX;

  final double cubicControlPointFactorY;

  static bool isOnAnyEdge(int index) {
    return isOnEdgeX(index) || isOnEdgeY(index);
  }

  static bool isOnCorner(int index) {
    return isOnEdgeX(index) && isOnEdgeY(index);
  }

  static bool isOnEdgeX(int index) {
    return index % 5 == 0 || index % 5 == 4;
  }

  static bool isOnEdgeY(int index) {
    return index < 5 || index > 19;
  }

  List<Color> get colors {
    return Iterable.generate(25, (index) {
      final color = selectedColors[index];
      if (color != null) {
        return color;
      }

      return quadColorLerper[index];
    }).toList();
  }

  Mesh25Data setVertices(List<Offset> vertices) {
    return Mesh25Data(
      vertices: vertices,
      selectedColors: selectedColors,
      quadColorLerper: quadColorLerper,
      tessellation: tessellation,
      cubicControlPointFactorX: cubicControlPointFactorX,
      cubicControlPointFactorY: cubicControlPointFactorY,
    );
  }

  Mesh25Data setTessellation(int value) {
    return Mesh25Data(
      vertices: vertices,
      selectedColors: selectedColors,
      quadColorLerper: quadColorLerper,
      tessellation: value,
      cubicControlPointFactorX: cubicControlPointFactorX,
      cubicControlPointFactorY: cubicControlPointFactorY,
    );
  }

  Mesh25Data setCubicControlpointFactorX(double value) {
    return Mesh25Data(
      vertices: vertices,
      selectedColors: selectedColors,
      quadColorLerper: quadColorLerper,
      tessellation: tessellation,
      cubicControlPointFactorX: value,
      cubicControlPointFactorY: cubicControlPointFactorY,
    );
  }

  Mesh25Data setCubicControlpointFactorY(double value) {
    return Mesh25Data(
      vertices: vertices,
      selectedColors: selectedColors,
      quadColorLerper: quadColorLerper,
      tessellation: tessellation,
      cubicControlPointFactorX: cubicControlPointFactorX,
      cubicControlPointFactorY: value,
    );
  }

  Mesh25Data setCornerColors({
    Color? colorTopLeft,
    Color? colorTopRight,
    Color? colorBottomLeft,
    Color? colorBottomRight,
  }) {
    final colorLerper = QuadColorLerper25(
      colorTopLeft: colorTopLeft ?? quadColorLerper.colorTopLeft,
      colorTopRight: colorTopRight ?? quadColorLerper.colorTopRight,
      colorBottomLeft: colorBottomLeft ?? quadColorLerper.colorBottomLeft,
      colorBottomRight: colorBottomRight ?? quadColorLerper.colorBottomRight,
    );
    return Mesh25Data(
      vertices: vertices,
      selectedColors: selectedColors,
      quadColorLerper: colorLerper,
      tessellation: tessellation,
      cubicControlPointFactorX: cubicControlPointFactorX,
      cubicControlPointFactorY: cubicControlPointFactorY,
    );
  }

  Mesh25Data setSelectedColors(Map<int, Color> selectedColors) {
    return Mesh25Data(
      vertices: vertices,
      selectedColors: selectedColors,
      quadColorLerper: quadColorLerper,
      tessellation: tessellation,
      cubicControlPointFactorX: cubicControlPointFactorX,
      cubicControlPointFactorY: cubicControlPointFactorY,
    );
  }
}

class QuadColorLerper25 {
  QuadColorLerper25({
    required this.colorTopLeft,
    required this.colorTopRight,
    required this.colorBottomLeft,
    required this.colorBottomRight,
  });

  factory QuadColorLerper25.lerp(
    QuadColorLerper25 a,
    QuadColorLerper25 b,
    double t,
  ) {
    return QuadColorLerper25(
      colorTopLeft: Color.lerp(
        a.colorTopLeft,
        b.colorTopLeft,
        t,
      )!,
      colorTopRight: Color.lerp(
        a.colorTopRight,
        b.colorTopRight,
        t,
      )!,
      colorBottomLeft: Color.lerp(
        a.colorBottomLeft,
        b.colorBottomLeft,
        t,
      )!,
      colorBottomRight: Color.lerp(
        a.colorBottomRight,
        b.colorBottomRight,
        t,
      )!,
    );
  }

  final Color colorTopLeft;
  final Color colorTopRight;
  final Color colorBottomLeft;
  final Color colorBottomRight;

  List<ValueGetter<Color>> get _lerpedColors => <ValueGetter<Color>>[
        () => color0x0,
        () => color0x1,
        () => color0x2,
        () => color0x3,
        () => color0x4,
        () => color1x0,
        () => color1x1,
        () => color1x2,
        () => color1x3,
        () => color1x4,
        () => color2x0,
        () => color2x1,
        () => color2x2,
        () => color2x3,
        () => color2x4,
        () => color3x0,
        () => color3x1,
        () => color3x2,
        () => color3x3,
        () => color3x4,
        () => color4x0,
        () => color4x1,
        () => color4x2,
        () => color4x3,
        () => color4x4,
      ];

  Color operator [](int index) {
    assert(index >= 0 && index < 25, 'Index out of bounds: $index');
    return _lerpedColors[index]();
  }

  late final color0x0 = colorTopLeft;
  late final color0x1 = interpolateColors(color0x0, color0x4, 0.25);
  late final color0x2 = interpolateColors(color0x0, color0x4, 0.5);
  late final color0x3 = interpolateColors(color0x0, color0x4, 0.75);
  late final color0x4 = colorTopRight;

  late final color1x0 = interpolateColors(color0x0, color4x0, 0.25);
  late final color1x1 = interpolateColors(color1x0, color1x4, 0.25);
  late final color1x2 = interpolateColors(color1x0, color1x4, 0.5);
  late final color1x3 = interpolateColors(color1x0, color1x4, 0.75);
  late final color1x4 = interpolateColors(color0x4, color4x4, 0.25);

  late final color2x0 = interpolateColors(color0x0, color4x0, 0.5);
  late final color2x1 = interpolateColors(color2x0, color2x4, 0.25);
  late final color2x2 = interpolateColors(color2x0, color2x4, 0.5);
  late final color2x3 = interpolateColors(color2x0, color2x4, 0.75);
  late final color2x4 = interpolateColors(color0x4, color4x4, 0.5);

  late final color3x0 = interpolateColors(color0x0, color4x0, 0.75);
  late final color3x1 = interpolateColors(color3x0, color3x4, 0.25);
  late final color3x2 = interpolateColors(color3x0, color3x4, 0.5);
  late final color3x3 = interpolateColors(color3x0, color3x4, 0.75);
  late final color3x4 = interpolateColors(color0x4, color4x4, 0.75);

  late final color4x0 = colorBottomLeft;
  late final color4x1 = interpolateColors(color4x0, color4x4, 0.25);
  late final color4x2 = interpolateColors(color4x0, color4x4, 0.5);
  late final color4x3 = interpolateColors(color4x0, color4x4, 0.75);
  late final color4x4 = colorBottomRight;
}

ui.Color interpolateColors(ui.Color color1, ui.Color color2, double t) {
  final c1 = Float32x4(
    color1.red / 255.0,
    color1.green / 255.0,
    color1.blue / 255.0,
    color1.alpha / 255.0,
  );
  final c2 = Float32x4(
    color2.red / 255.0,
    color2.green / 255.0,
    color2.blue / 255.0,
    color2.alpha / 255.0,
  );

  final interpolated = lerpFloat32x4(c1, c2, t);
  final red = (interpolated.x * 255.0).round();
  final green = (interpolated.y * 255.0).round();
  final blue = (interpolated.z * 255.0).round();
  final alpha = (interpolated.w * 255.0).round();

  return ui.Color.fromARGB(alpha, red, green, blue);
}

Float32x4 lerpFloat32x4(Float32x4 a, Float32x4 b, double t) {
  final x = a.x + (b.x - a.x) * t;
  final y = a.y + (b.y - a.y) * t;
  final z = a.z + (b.z - a.z) * t;
  final w = a.w + (b.w - a.w) * t;

  return Float32x4(x, y, z, w);
}
