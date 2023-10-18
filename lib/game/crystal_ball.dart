import 'dart:math';

import 'package:crystal_ball/game/components/camera_target.dart';
import 'package:crystal_ball/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/painting.dart';

class CrystalWorld extends World {
  CrystalWorld({
    // ignore: strict_raw_type
    required List<FlameBlocProvider> providers,
    super.priority = -0x7fffffff,
  }) {
    flameMultiBlocProvider = FlameMultiBlocProvider(
      providers: providers,
      children: [
        TheBall(position: Vector2.zero()),
        Ground(),
      ],
    );
    add(flameMultiBlocProvider);
    add(cameraTarget);
  }

  late final FlameMultiBlocProvider flameMultiBlocProvider;

  late final cameraTarget = CameraTarget();
}

class CrystalBallGame extends FlameGame<CrystalWorld> {
  CrystalBallGame({
    required this.textStyle,
    required this.random,
    required this.gameCubit,
  }) : super(
          camera: CameraComponent.withFixedResolution(
            width: kCameraSize.width,
            height: kCameraSize.height,
            backdrop: RectangleComponent(
              paint: Paint()..color = const Color(0xFF000000),
              size: kCameraSize.asVector2,
              priority: -0x7ffffffF,
            ),
          ),
          world: CrystalWorld(
            providers: [
              FlameBlocProvider<GameCubit, GameState>.value(
                value: gameCubit,
              ),
            ],
          ),
          children: [
            PlatformSpawner(random: random),
          ],
        ) {
    camera.follow(world.cameraTarget);
    images.prefix = '';
  }

  @override
  bool get debugMode => true;

  final TextStyle textStyle;

  final Random random;

  final GameCubit gameCubit;

  int counter = 0;

  @override
  Color backgroundColor() => const Color(0xFF000000);

  @override
  Future<void> onLoad() async {}
}
