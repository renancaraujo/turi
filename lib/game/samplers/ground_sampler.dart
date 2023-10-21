import 'dart:ui';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/extensions.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class GroundSamplerOwner extends SamplerOwner {
  GroundSamplerOwner(
    super.shader, {
    required this.world,
    required this.concreteTexture,
  });

  final CrystalWorld world;
  final Image concreteTexture;

  @override
  int get passes => 1;

  double time = 0;

  @override
  void update(double dt) {
    super.update(dt);
    time += dt;
  }

  @override
  void sampler(List<Image> images, Size size, Canvas canvas) {
    final originY = world.cameraTarget.y - kCameraSize.height / 2;

    final groundpos = world.ground.rectangle.top + 40;

    final uvGround = (groundpos - originY) / (kCameraSize.asVector2.y);

    shader
      ..setFloatUniforms((value) {
        value
          ..setSize(size)
          ..setFloat(uvGround)
          ..setFloat(time)
          ..setVector64(concreteTexture.size);
      })
      ..setImageSampler(0, images[0])
      ..setImageSampler(1, concreteTexture);

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
