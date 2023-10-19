import 'dart:math';
import 'dart:ui';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';

enum PlatformColor {
  red._(Color(0xFFFF0000), 1),
  orange._(Color(0xFFFFA500), 2),
  blue._(Color(0xFF2A48DF), 30),
  green._(Color(0xFF00FF00), 100);

  const PlatformColor._(this.color, this.rarity);

  final Color color;
  final int rarity;

  Paint get paint => Paint()..color = color;

  static PlatformColor random(Random random) =>
      values[random.nextInt(values.length)];

  static PlatformColor rarityRandom(Random random) {
    final totalRarity = values.fold<int>(
      0,
      (previousValue, element) => previousValue + element.rarity,
    );
    final randomValue = random.nextInt(totalRarity);
    var currentRarity = 0;
    for (final color in values) {
      currentRarity += color.rarity;
      if (randomValue < currentRarity) {
        return color;
      }
    }
    return values.last;
  }
}

class Platform extends PositionComponent
    with
        HasPaint,
        HasGameRef<CrystalBallGame>,
        FlameBlocListenable<GameCubit, GameState> {
  Platform({
    required Vector2 super.position,
    required Vector2 super.size,
    required this.color,
  }) : super(
          anchor: Anchor.center,
          priority: 1000,
        ) {
    add(
      _InerPlatform(
        size: size,
        paint: paint,
      ),
    );
    add(RectangleHitbox(size: size));
  }

  @override
  // ignore: overridden_fields
  late final Paint paint = color.paint;

  late final effectController = EffectController(
    duration: kPlatformSpawnDuration,
  );

  final PlatformColor color;

  @override
  void update(double dt) {
    super.update(dt);
    if (!bloc.isPlaying) return;
    if (y > game.world.reaper.y) {
      removeFromParent();
    }
  }
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
