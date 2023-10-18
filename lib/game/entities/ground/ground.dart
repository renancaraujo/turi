import 'dart:ui';

import 'package:crystal_ball/game/constants.dart';
import 'package:flame/components.dart';

class Ground extends Component {
  Ground()
      : super(
          children: [
            _Rectangle(),
          ],
        );
}

class _Rectangle extends RectangleComponent {
  _Rectangle()
      : super(
          anchor: Anchor.topCenter,
          paint: Paint()..color = const Color(0xFF1F1616),
          position: Vector2(0, kPlayerSize.height / 2),
          size: Vector2(
            kCameraSize.width,
            kCameraSize.height / 2,
          ),
        );
}
