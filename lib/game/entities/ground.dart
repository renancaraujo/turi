import 'dart:ui';

import 'package:crystal_ball/game/constants.dart';
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
  // TODO: implement debugMode
  bool get debugMode => true;
}

class _Rectangle extends RectangleComponent
    with CollisionCallbacks, ParentIsA<Ground> {
  _Rectangle()
      : super(
          anchor: Anchor.topCenter,
          paint: Paint()..color = const Color(0xFF1F1616),
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
