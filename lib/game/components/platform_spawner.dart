import 'package:crystal_ball/game/game.dart';
import 'package:flame/components.dart';
import 'dart:math' as math;

class PlatformSpawner extends Component with HasGameRef<CrystalBallGame> {
  PlatformSpawner({
    required this.seed,
  }) {
    timer = initialTimer;
  }

  final math.Random seed;

  static const interval = 2.0;

  late Timer timer;

  Timer get initialTimer => Timer(
        0,
        onTick: onTick,
        autoStart: false,
      );

  void onTick() {
    // add next latter
    // final nextPeriod = seed.nextDouble() * 0.5 + interval;
    // timer = Timer(
    //   nextPeriod,
    //   onTick: onTick,
    // );

    game.world.add(
      Platform(
        position: Vector2.zero(),
        size: Vector2(100, 20),
        color: PlatformColor.green,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
  }
}
