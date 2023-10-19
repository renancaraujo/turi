import 'dart:ui';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/components.dart';

class Wall extends RectangleComponent with HasGameRef<CrystalBallGame> {
  Wall()
      : super(
          position: Vector2(0, 100),
          size: Vector2(kCameraSize.width, kCameraSize.height),
          anchor: Anchor.bottomCenter,
          paint: Paint()..color = const Color(0xFF54207E),
        );

  @override
  void update(double dt) {
    super.update(dt);
    height =
        game.world.cameraTarget.position.y.abs() + 100 + kCameraSize.height / 2;
  }
}
