import 'dart:ui';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/components.dart';

class TheBall extends PositionComponent {
  TheBall({
    required Vector2 super.position,
  }) : super(
          anchor: Anchor.center,
          children: [
            _Circle(radius: kPlayerRadius),
          ],
        );
}

class _Circle extends CircleComponent {
  _Circle({
    required double super.radius,
  }) : super(
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFFFFFFFF),
        );
}
