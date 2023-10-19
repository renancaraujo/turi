import 'package:crystal_ball/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Reaper extends PositionComponent with HasGameRef<CrystalBallGame> {
  Reaper()
      : super(
          position: Vector2(0, 0),
          size: Vector2(kCameraSize.width * 2, 100),
          anchor: Anchor.topCenter,
          children: [
            RectangleHitbox(),
          ],
        );

  @override
  void update(double dt) {
    super.update(dt);
    position.y = game.world.cameraTarget.position.y +
        (kCameraSize.height + kReaperTolerance) / 2;
  }
}
