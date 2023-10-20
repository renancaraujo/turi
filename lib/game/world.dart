import 'dart:math';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/camera.dart';
import 'package:flame/extensions.dart';
import 'package:flame_bloc/flame_bloc.dart';

class CrystalWorld extends World {
  CrystalWorld({
    // ignore: strict_raw_type
    required List<FlameBlocProvider> providers,
    required this.random,
    super.priority = -0x7fffffff,
  }) {
    flameMultiBlocProvider = FlameMultiBlocProvider(
      providers: providers,
      children: [
        PlatformSpawner(random: random),
        GameStateController(),
        reaper = Reaper(),
        theBall = TheBall(position: Vector2.zero()),
        Ground(),
      ],
    );

    add(flameMultiBlocProvider);

    add(cameraTarget);

    // add(
    //   Platform(
    //     position: Vector2(0, -400),
    //     random: random,
    //     size: Vector2(kPlatformMinWidth + 100, kPlatformHeight),
    //     color: PlatformColor.orange,
    //   ),
    // );
  }

  late final FlameMultiBlocProvider flameMultiBlocProvider;

  late final cameraTarget = CameraTarget();

  late final Reaper reaper;

  late final TheBall theBall;

  final Random random;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    children.register<Platform>();
  }

  List<Platform> getPlatforms() {
    return children.query<Platform>();
  }

}
