import 'dart:math';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/painting.dart';

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
        KeyboardHandlerSync(),
        directionalController = DirectionalController(),
        theBall = TheBall(position: Vector2.zero()),
        Ground(),
        reaper = Reaper(),
      ],
    );
    add(flameMultiBlocProvider);
    add(cameraTarget);
  }

  late final FlameMultiBlocProvider flameMultiBlocProvider;

  late final cameraTarget = CameraTarget();

  late final DirectionalController directionalController;

  late final Reaper reaper;

  late final TheBall theBall;

  final Random random;
}

class CrystalBallGame extends FlameGame<CrystalWorld>
    with HasKeyboardHandlerComponents, HasCollisionDetection {
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
            random: random,
            providers: [
              FlameBlocProvider<GameCubit, GameState>.value(
                value: gameCubit,
              ),
            ],
          ),
        ) {
    camera.follow(world.cameraTarget);
    images.prefix = '';
  }

  final TextStyle textStyle;

  final Random random;

  final GameCubit gameCubit;

  int counter = 0;

  @override
  Color backgroundColor() => const Color(0xFF000000);

  @override
  Future<void> onLoad() async {}
}
