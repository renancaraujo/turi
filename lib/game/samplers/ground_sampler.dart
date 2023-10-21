import 'dart:ui';

import 'package:crystal_ball/game/game.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class GroundSamplerOwner extends SamplerOwner {
  GroundSamplerOwner(super.shader, this.world);

  final CrystalWorld world;

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

    final groundpos = world.ground.rectangle.top;

    final uvGround = (groundpos - originY) / (kCameraSize.asVector2.y);

    // final boundaryL = world.cameraTarget.x - kCameraSize.width / 2 + 100;
    // final boundaryR = world.cameraTarget.x + kCameraSize.width / 2 - 100;
    //
    // final uvBoundaryL = (boundaryL - origin.x) /
    //     (cameraComponent!.visibleWorldRect.size.toVector2().x);
    // final uvBoundaryR = (boundaryR - origin.x) /
    //     (cameraComponent!.visibleWorldRect.size.toVector2().x);

    // print(cameraComponent!.visibleWorldRect.size);

    shader
      ..setFloatUniforms((value) {
        value
          ..setSize(size)
          ..setFloat(uvGround)
          ..setFloat(0)
          ..setFloat(1)
          ..setFloat(time);
      })
      ..setImageSampler(0, images[0]);

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

extension on UniformsSetter {}
