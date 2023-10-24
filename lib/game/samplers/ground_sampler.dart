import 'dart:ui';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/camera.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_shaders/flutter_shaders.dart';

class GroundSamplerOwner extends SamplerOwner {
  GroundSamplerOwner(
    super.shader,
    this.rocksShader,
    this.fogShader,
    this.innerCamera, {
    required this.world,
  });

  final CameraComponent innerCamera;

  final CrystalWorld world;

  final FragmentShader rocksShader;
  final FragmentShader fogShader;

  @override
  int get passes => 2;

  double time = 0;

  @override
  void update(double dt) {
    super.update(dt);
    time += dt;
  }

  Vector2 worldToUv(Vector2 coord) {
    final cameraViewport = cameraComponent!.viewport;
    return innerCamera.localToGlobal(coord)..divide(cameraViewport.size);
  }

  @override
  void sampler(List<Image> images, Size size, Canvas canvas) {
    final groundpos = world.ground.rectangle.absolutePosition + Vector2(0, 100);
    final uvGround = worldToUv(groundpos).y;

    final ssize = (innerCamera.viewport.size - Vector2.all(2))..ceil();
    final spos = (innerCamera.viewport.position + Vector2.all(2))..ceil();

    canvas.clipRect(spos.toOffset() & ssize.toSize(), doAntiAlias: false);

    shader
      ..setFloatUniforms((value) {
        value
          ..setSize(size)
          ..setFloat(uvGround)
          ..setFloat(time);
      })
      ..setImageSampler(0, images[0]);

    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = shader
        ..blendMode = BlendMode.srcOver,
    );

    // fog

    applyFog(size, canvas);

    // rocks

    rocksShader
      ..setFloatUniforms((value) {
        value.setSize(size);
      })
      ..setImageSampler(0, images[1])
      ..setImageSampler(1, images[0]);

    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = rocksShader,
    );
  }

  void applyFog(Size size, Canvas canvas) {
    fogShader.setFloatUniforms((value) {
      value.setSize(size);

      final groundpos =
          world.ground.rectangle.absolutePosition + Vector2(0, 1800);
      final uvGround = worldToUv(groundpos).y;

      final cameraVerticalPos = world.cameraTarget.position.clone()
        ..absolute()
        ..y *= 1.9;

      final uvCameraVerticalPos = cameraVerticalPos
        ..divide(kCameraSize.asVector2);

      value
        ..setFloat(uvGround)
        ..setFloat(uvCameraVerticalPos.y)
        ..setFloat(3.4)
        ..setFloat(time * 1.2);
    });

    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = fogShader
        ..blendMode = BlendMode.plus,
    );
  }
}

extension on UniformsSetter {}
