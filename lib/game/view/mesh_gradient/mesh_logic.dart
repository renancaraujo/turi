import 'dart:ui' as ui;

import 'package:crystal_ball/game/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class AnimatedMeshGradient extends StatelessWidget {
  const AnimatedMeshGradient({
    required this.data,
    required this.builder,
    required this.duration,
    super.key,
  });

  final Mesh25Data data;
  final Duration duration;

  final ValueWidgetBuilder<Mesh25Data> builder;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Mesh25DataTween(begin: data, end: data),
      duration: duration,
      curve: Curves.easeInOut,
      builder: builder,
    );
  }
}

class MeshGradient extends StatelessWidget {
  const MeshGradient({
    required this.data,
    super.key,
    this.showMesh = false,
    this.showGrain = false,
  });

  final Mesh25Data data;

  final bool showGrain;
  final bool showMesh;

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'shaders/mesh_25_gradient.glsl',
      (BuildContext context, ui.FragmentShader shader, Widget? child) {
        return CustomPaint(
          painter: MeshGradientPainter(
            shader,
            data: data,
            showMesh: showMesh,
            showGrain: showGrain,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

final _meshGeometry = PlaneGeometry(xSegments: 4, ySegments: 4);

class MeshGradientPainter extends CustomPainter {
  MeshGradientPainter(
    this.shader, {
    required this.data,
    required this.showMesh,
    required this.showGrain,
  });

  final ui.FragmentShader shader;

  final Mesh25Data data;
  final bool showGrain;
  final bool showMesh;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    shader.setFloatUniforms((s) {
      s
        ..setSize(size)
        ..setFloat(showGrain ? 1.0 : 0.0)
        ..setColors(data.colors, premultiply: true);

      for (var i = 0; i < data.vertices.length; i++) {
        final hasBias = data.selectedColors.containsKey(i);
        s.setFloat(hasBias ? 1.0 : 0.0);
      }
    });

    final paintShader = Paint()..shader = shader;

    final (vertices, triangles) = _meshGeometry.getVertices(
      size,
      data.vertices,
      Mesh25Data.initialVertices,
      data.tessellation,
      data.cubicControlPointFactorX,
      data.cubicControlPointFactorY,
    );

    canvas.drawVertices(
      vertices,
      BlendMode.dst,
      paintShader,
    );

    if (!showMesh) {
      return;
    }

    final groups = <List<Offset>>[];
    for (var i = 0; i < triangles.length; i += 3) {
      groups.add(
        [triangles[i], triangles[i + 1], triangles[i + 2], triangles[i]],
      );
    }

    for (final group in groups) {
      canvas.drawPoints(
        ui.PointMode.polygon,
        group,
        Paint()
          ..color = const Color(0xFFFFFFFF)
          ..strokeWidth = 0.5
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

ColorTween colorTween(Color begin, Color end) {
  return ColorTween(begin: begin, end: end);
}

class Mesh25DataTween extends Tween<Mesh25Data> {
  Mesh25DataTween({super.begin, super.end});

  @override
  Mesh25Data lerp(double t) => Mesh25Data.lerp(begin!, end!, t);
}
