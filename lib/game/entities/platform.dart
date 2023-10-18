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
  }) : super(children: [
          _InerPlatform(
            size: size,
            paint: color.paint,
          ),
        ]);

  final PlatformColor color;
}

class _InerPlatform extends RectangleComponent with ParentIsA<Platform> {
  _InerPlatform({
    required Vector2 super.size,
    required Paint super.paint,
  }) : super(anchor: Anchor.center);
}
