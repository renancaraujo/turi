import 'dart:io';

import 'package:binarize/binarize.dart'
    hide
        boolean,
        float32,
        float64,
        int16,
        int32,
        int64,
        int8,
        string,
        string16,
        string32,
        string64,
        string8,
        uint16,
        uint32,
        uint64,
        uint8;
import 'package:binarize/binarize.dart' as binarize_types show float32, uint8;
import 'package:crystal_ball/game/game.dart';
import 'package:flutter/cupertino.dart';

String bytesToHex(List<int> bytes) {
  final uncompressed = zlib.encode(bytes);
  return uncompressed.map((e) {
    return e.toRadixString(16).padLeft(2, '0');
  }).join();
}

List<int> hexToBytes(String hex) {
  final bytes = Uint8List(hex.length ~/ 2);
  for (var i = 0; i < hex.length; i += 2) {
    final chars = hex.substring(i, i + 2);
    final ls = int.parse(chars, radix: 16);
    bytes[i ~/ 2] = ls;
  }

  return zlib.decode(bytes);
}

String getHashFromAMesh25(Mesh25Data data) {
  final raw = Mesh25DataRaw.fromMesh25Data(data);
  final writer = Payload.write()
    ..set(SelectedVerticesPayload.type, raw.selectedVertices)
    ..set(SelectedColorsPayload.type, raw.selectedColors)
    ..set(QuadColorLerper25Payload.type, raw.quadColorLerper)
    ..set(binarize_types.uint8, raw.tessellation)
    ..set(binarize_types.float32, raw.cubicControlPointFactorX)
    ..set(binarize_types.float32, raw.cubicControlPointFactorY);

  final bytes = binarize(writer);

  return bytesToHex(bytes);
}

Mesh25Data getAMesh25FromHash(String hash) {
  final bytes = hexToBytes(hash);

  final reader = Payload.read(bytes);
  final raw = Mesh25DataRaw(
    reader.get(SelectedVerticesPayload.type),
    reader.get(SelectedColorsPayload.type),
    reader.get(QuadColorLerper25Payload.type),
    reader.get(binarize_types.uint8),
    reader.get(binarize_types.float32),
    reader.get(binarize_types.float32),
  );
  return raw.unRaw();
}

class ColorPayload extends PayloadType<Color> {
  const ColorPayload();

  static const type = ColorPayload();

  @override
  int length(Color value) => 4;

  @override
  Color get(ByteData data, int offset) {
    return Color(data.getUint32(offset));
  }

  @override
  void set(Color value, ByteData data, int offset) {
    data.setUint32(offset, value.value);
  }
}

class QuadColorLerper25Payload extends PayloadType<QuadColorLerper25> {
  const QuadColorLerper25Payload();

  static const type = QuadColorLerper25Payload();

  @override
  int length(QuadColorLerper25 value) => 16;

  @override
  QuadColorLerper25 get(ByteData data, int offset) {
    final colorTopLeft = Color(data.getUint32(offset));
    final colorTopRight = Color(data.getUint32(offset + 4));
    final colorBottomLeft = Color(data.getUint32(offset + 8));
    final colorBottomRight = Color(data.getUint32(offset + 12));

    return QuadColorLerper25(
      colorTopLeft: colorTopLeft,
      colorTopRight: colorTopRight,
      colorBottomLeft: colorBottomLeft,
      colorBottomRight: colorBottomRight,
    );
  }

  @override
  void set(QuadColorLerper25 value, ByteData data, int offset) {
    data
      ..setUint32(offset, value.colorTopLeft.value)
      ..setUint32(offset + 4, value.colorTopRight.value)
      ..setUint32(offset + 8, value.colorBottomLeft.value)
      ..setUint32(offset + 12, value.colorBottomRight.value);
  }
}

class SelectedColorsPayload extends PayloadType<Map<int, Color>> {
  const SelectedColorsPayload();

  static const type = SelectedColorsPayload();

  @override
  int length(Map<int, Color> value) {
    return value.length * 5 + 1;
  }

  @override
  Map<int, Color> get(ByteData data, int offset) {
    final length = data.getUint8(offset);
    final map = <int, Color>{};
    for (var i = 0; i < length; i++) {
      final index = data.getUint8(offset + 1 + i * 5);
      final color = Color(data.getUint32(offset + 2 + i * 5));
      map[index] = color;
    }
    return map;
  }

  @override
  void set(Map<int, Color> value, ByteData data, int offset) {
    data.setUint8(offset, value.length);
    var i = 0;
    for (final entry in value.entries) {
      data
        ..setUint8(offset + 1 + i * 5, entry.key)
        ..setUint32(offset + 2 + i * 5, entry.value.value);
      i++;
    }
  }
}

class SelectedVerticesPayload extends PayloadType<Map<int, Offset>> {
  const SelectedVerticesPayload();

  static const type = SelectedVerticesPayload();

  @override
  int length(Map<int, Offset> value) {
    final length = value.length;
    if (length == 25) {
      return 1 + 25 * (2 * 4);
    }
    return 1 + value.length * (2 * 4 + 1);
  }

  @override
  Map<int, Offset> get(ByteData data, int offset) {
    final length = data.getUint8(offset);
    final map = <int, Offset>{};

    if (length == 25) {
      for (var i = 0; i < length; i++) {
        final index = i;
        final x = data.getFloat32(offset + 1 + i * 8);
        final y = data.getFloat32(offset + 5 + i * 8);
        map[index] = Offset(x, y);
      }
      return map;
    }

    for (var i = 0; i < length; i++) {
      final index = data.getUint8(offset + 1 + i * 9);
      final x = data.getFloat32(offset + 2 + i * 9);
      final y = data.getFloat32(offset + 6 + i * 9);
      map[index] = Offset(x, y);
    }
    return map;
  }

  @override
  void set(Map<int, Offset> value, ByteData data, int offset) {
    data.setUint8(offset, value.length);

    if (value.length == 25) {
      var i = 0;
      for (final entry in value.entries) {
        data
          ..setFloat32(offset + 1 + i * 8, entry.value.dx)
          ..setFloat32(offset + 5 + i * 8, entry.value.dy);
        i++;
      }
      return;
    }
    var i = 0;
    for (final entry in value.entries) {
      data
        ..setUint8(offset + 1 + i * 9, entry.key)
        ..setFloat32(offset + 2 + i * 9, entry.value.dx)
        ..setFloat32(offset + 6 + i * 9, entry.value.dy);
      i++;
    }
  }
}

@immutable
class Mesh25DataRaw {
  const Mesh25DataRaw(
    this.selectedVertices,
    this.selectedColors,
    this.quadColorLerper,
    this.tessellation,
    this.cubicControlPointFactorX,
    this.cubicControlPointFactorY,
  );

  factory Mesh25DataRaw.fromMesh25Data(Mesh25Data data) {
    final allVertices = data.vertices;
    final initialVertices = Mesh25Data.initialVertices;

    final selectedVertices = <int, Offset>{};
    for (var i = 0; i < 25; i++) {
      final vertex = allVertices[i];
      if (vertex == initialVertices[i]) {
        continue;
      }
      selectedVertices[i] = vertex;
    }

    return Mesh25DataRaw(
      selectedVertices,
      data.selectedColors,
      data.quadColorLerper,
      data.tessellation,
      data.cubicControlPointFactorX,
      data.cubicControlPointFactorY,
    );
  }

  Mesh25Data unRaw() {
    Offset getInitialVertex(int index) {
      final x = index % 5 / 4;
      final y = index ~/ 5 / 4;
      return Offset(x, y);
    }

    final vertices = List<Offset>.generate(25, (index) {
      return selectedVertices[index] ?? getInitialVertex(index);
    });

    return Mesh25Data(
      vertices: vertices,
      selectedColors: selectedColors,
      quadColorLerper: quadColorLerper,
      tessellation: tessellation,
      cubicControlPointFactorX: cubicControlPointFactorX,
      cubicControlPointFactorY: cubicControlPointFactorY,
    );
  }

  final Map<int, Offset> selectedVertices;
  final Map<int, Color> selectedColors;
  final QuadColorLerper25 quadColorLerper;
  final int tessellation;
  final double cubicControlPointFactorX;
  final double cubicControlPointFactorY;
}
