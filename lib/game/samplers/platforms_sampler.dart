import 'dart:ui';

import 'package:crystal_ball/game/game.dart';

class PlatformsSamplerOwner extends SamplerOwner {
  PlatformsSamplerOwner(super.shader);

  @override
  void sampler(Image image, Canvas canvas) {
    canvas.drawImage(
      image,
      // Offset(-450, -800),
      Offset.zero,
      Paint()..color = const Color(0x5500FF00),
    );
  }
}
