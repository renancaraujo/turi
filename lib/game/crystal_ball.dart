import 'dart:math';

import 'package:crystal_ball/game/components/platform_spawner.dart';
import 'package:crystal_ball/l10n/l10n.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';

class CrystalWorld extends World {}

class CrystalBallGame extends FlameGame {
  CrystalBallGame({
    required this.l10n,
    required this.textStyle,
    required this.random,
  }) : super(
          world: CrystalWorld(),
          children: [
            PlatformSpawner(random: random),
          ],
        ) {
    images.prefix = '';
  }

  final AppLocalizations l10n;

  final TextStyle textStyle;

  final Random random;

  int counter = 0;

  @override
  Color backgroundColor() => const Color(0xFF2A48DF);

  @override
  Future<void> onLoad() async {
    camera.viewfinder.position = size / 2;
    camera.viewfinder.zoom = 8;
  }
}
