import 'dart:ui';

import 'package:crystal_ball/game/game.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class PlatformsSamplerOwner extends SamplerOwner {
  PlatformsSamplerOwner(super.shader);

  @override
  void sampler(Image image, Size size, Canvas canvas) {
    shader
      ..setFloatUniforms((value) {
        value.setSize(size);
      })
      ..setImageSampler(0, image);

    canvas
      ..save()
      ..drawRect(Offset.zero & size, Paint()..shader = shader)
      ..restore();
  }
}
