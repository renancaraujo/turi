import 'dart:ui';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/extensions.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class TheBallSamplerOwner extends SamplerOwner {
  TheBallSamplerOwner(super.shader, this.world);

  final CrystalWorld world;

  @override
  int get passes => 0;

  @override
  void sampler(List<Image> images, Size size, Canvas canvas) {
    if (canvas is SamplerCanvas<GroundSamplerOwner>) {
      if (canvas.pass == 1) {
        return;
      }
    }

    final origin = cameraComponent!.visibleWorldRect.topLeft.toVector2();

    final theBall = world.theBall;

    final ballpos = theBall.absolutePosition;

    final uvBall = (ballpos - origin)..divide(kCameraSize.asVector2);

    final velocity = theBall.velocity.clone() / 1600;

    shader.setFloatUniforms((value) {
      value
        ..setSize(size)
        ..setVector64(uvBall)
        ..setVector64(-velocity)
        ..setFloat(theBall.gama)
        ..setFloat(theBall.radius);
    });

    canvas
      ..save()
      ..drawRect(
        Offset.zero & size,
        Paint()
          ..shader = shader
          ..blendMode = BlendMode.lighten,
      )
      ..restore();
  }
}

extension on UniformsSetter {
  void setVector64(Vector vector) {
    setFloats(vector.storage);
  }
}
