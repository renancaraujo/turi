import 'dart:ui';

import 'package:flame/components.dart';

enum PlatformColor {
  orange._(Color(0xFFFFA500)),
  blue._(Color(0xFF2A48DF)),
  green._(Color(0xFF00FF00));

  const PlatformColor._(this.color);

  final Color color;

  Paint get paint => Paint()..color = color;
}

class Platform extends PositionComponent {
  Platform({
    required Vector2 super.position,
    required Vector2 super.size,
    required this.color,
  }) : super(
          anchor: Anchor.center,
          children: [
            _InerPlatform(
              size: size,
              paint: color.paint,
            ),
          ],
        );

  final PlatformColor color;
}

class _InerPlatform extends Component with ParentIsA<Platform> {
  _InerPlatform({
    required Vector2 size,
    required Paint paint,
  }) : super(
          children: [
            RectangleComponent(
              position: Vector2(size.x / 2, size.y / 2),
              size: Vector2(size.x - (size.y), size.y),
              anchor: Anchor.center,
              paint: paint,
            ),
            CircleComponent(
              position: Vector2(size.y / 2, size.y / 2),
              radius: size.y / 2,
              paint: paint,
              anchor: Anchor.center,
            ),
            CircleComponent(
              position: Vector2(size.x - size.y / 2, size.y / 2),
              radius: size.y / 2,
              paint: paint,
              anchor: Anchor.center,
            ),
          ],
        );
}
