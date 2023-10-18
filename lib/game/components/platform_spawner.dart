import 'dart:math';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/components.dart';

class PlatformSpawner extends Component with HasGameRef<CrystalBallGame> {
  PlatformSpawner({
    required this.random,
  });

  final Random random;

  static const interval = 2.0;

  @override
  void onLoad() {
    game.world.add(
      Platform(
        position: Vector2(0, -200),
        size: Vector2(200, 35),
        color: PlatformColor.green,
      ),
    );
  }
}
