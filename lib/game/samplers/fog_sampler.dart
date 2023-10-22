import 'dart:ui';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/extensions.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class FogSamplerOwner extends SamplerOwner {
  FogSamplerOwner(super.shader, this.world);

  final CrystalWorld world;

  @override
  int get passes => 0;

  double time = 0;

  @override
  void update(double dt) {
    super.update(dt);
    time += dt;
  }

  @override
  void sampler(List<Image> images, Size size, Canvas canvas) {
    if (canvas is SamplerCanvas<GroundSamplerOwner>) {
      if (canvas.pass == 1) {
        return;
      }
    }

    applyFog(size, canvas);
  }

  void applyFog(Size size, Canvas canvas) {
    final origin = cameraComponent!.visibleWorldRect.topLeft.toVector2();

    shader.setFloatUniforms((value) {
      value.setSize(size);

      final groundpos =
          world.ground.rectangle.absolutePosition + Vector2(0, 200);
      final uvGround = (groundpos - origin)..divide(kCameraSize.asVector2);

      final cameraVerticalPos = world.cameraTarget.position.clone()..absolute();

      final uvCameraVerticalPos = cameraVerticalPos
        ..divide(kCameraSize.asVector2);

      value
        ..setFloat(uvGround.y)
        ..setFloat(uvCameraVerticalPos.y)
        ..setFloat(0.3)
        ..setFloat(time);
    });

    canvas
      ..save()
      ..drawRect(
        Offset.zero & size,
        Paint()
          ..shader = shader
          ..blendMode = BlendMode.darken,
      )
      ..restore();
  }
}

extension on UniformsSetter {}
