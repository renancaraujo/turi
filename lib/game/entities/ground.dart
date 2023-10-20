import 'dart:ui';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Ground extends Component {
  Ground()
      : super(
          children: [
            _Rectangle(),
          ],
        );

  @override
  void renderTree(Canvas canvas) {
    if (canvas is SamplerCanvas) {
      if (canvas.owner is PlatformsSamplerOwner) {
        return;
      }
    }
    super.renderTree(canvas);
  }
}

class _Rectangle extends PositionComponent
    with CollisionCallbacks, ParentIsA<Ground> {
  _Rectangle()
      : super(
          anchor: Anchor.topCenter,
          position: Vector2(0, kPlayerSize.height / 2),
          size: Vector2(
            kCameraSize.width,
            kCameraSize.height / 2,
          ),
          children: [
            RectangleHitbox(
              size: Vector2(
                kCameraSize.width,
                kCameraSize.height / 2,
              ),
            ),
            RectangleHitbox(
              position: Vector2(0, kPlayerRadius),
              size: Vector2(
                kCameraSize.width,
                kCameraSize.height / 2,
              ),
            ),
            RectangleHitbox(
              position: Vector2(0, kPlayerRadius * 2),
              size: Vector2(
                kCameraSize.width,
                kCameraSize.height / 2,
              ),
            ),
          ],
        );
}
