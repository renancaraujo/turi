import 'dart:ui';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_shaders/flutter_shaders.dart';

class PlatformsSamplerOwner extends SamplerOwner {
  PlatformsSamplerOwner(super.shader, this.world);

  final CrystalWorld world;

  late List<Platform> _platforms;

  @override
  int get passes => 0;

  @override
  void update(double dt) {
    super.update(dt);
    _platforms = world.getPlatforms();
  }

  @override
  void sampler(List<Image> images, Size size, Canvas canvas) {
    if (canvas is SamplerCanvas<GroundSamplerOwner>) {
      if (canvas.pass == 1) {
        return;
      }
    }

    shader.setFloatUniforms((value) {
      value
        ..setSize(size)
        ..setPlatforms(_platforms, cameraComponent!);
    });

    canvas
      ..save()
      ..drawRect(
        Offset.zero & size,
        Paint()
          ..shader = shader
          ..blendMode = BlendMode.multiply,
      )
      ..restore();
  }
}

extension on UniformsSetter {
  void setVector64(Vector vector) {
    setFloats(vector.storage);
  }

  void setRGB(Color color) {
    setFloat(color.red / 255);
    setFloat(color.green / 255);
    setFloat(color.blue / 255);
  }

  void setPlatforms(List<Platform> platforms, CameraComponent cameraComponent) {
    final origin = cameraComponent.visibleWorldRect.topLeft.toVector2();

    // positions
    for (var i = 0; i < 18; i++) {
      if (i >= platforms.length) {
        setVector64(Vector2.zero());
        setVector64(Vector2.zero());
        continue;
      }

      final platform = platforms[i];
      final abscl = platform.absolutePositionOfAnchor(Anchor.centerLeft);
      final uvcl = (abscl - origin)..divide(kCameraSize.asVector2);
      setVector64(uvcl);

      final abscr = platform.absolutePositionOfAnchor(Anchor.centerRight);
      final uvcr = (abscr - origin)..divide(kCameraSize.asVector2);
      setVector64(uvcr);
    }

    // colorsL
    for (var i = 0; i < 18; i++) {
      if (i >= platforms.length) {
        setRGB(Colors.transparent);
        continue;
      }
      final platform = platforms[i];

      final colorL = platform.gradient[0];
      setRGB(colorL);
    }

    // colorsR
    for (var i = 0; i < 18; i++) {
      if (i >= platforms.length) {
        setRGB(Colors.transparent);
        continue;
      }
      final platform = platforms[i];

      final colorR = platform.gradient[1];
      setRGB(colorR);
    }

    // glow gama

    for (var i = 0; i < 18; i++) {
      if (i >= platforms.length) {
        setFloat(0);
        continue;
      }
      final platform = platforms[i];

      final distance = platform.glowGama;
      setFloat(distance);
    }
  }
}
