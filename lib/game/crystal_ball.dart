import 'dart:math';
import 'dart:ui';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/painting.dart';

class CrystalBallGame extends FlameGame<CrystalWorld>
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  CrystalBallGame({
    required this.textStyle,
    required this.random,
    required this.gameCubit,
    required this.platformsShader,
    required this.pixelRatio,
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

    add(
      SamplerCamera.withFixedResolution(
        world: camera.world,
        width: kCameraSize.width,
        height: kCameraSize.height,
        pixelRatio: pixelRatio,
        samplerOwner: PlatformsSamplerOwner(platformsShader),
        backdrop: RectangleComponent(
          paint: Paint()..color = const Color(0xFF000000),
          size: kCameraSize.asVector2,
          priority: -0x7ffffffF,
        ),
      )..follow(world.cameraTarget),
    );
  }

  final TextStyle textStyle;
  final Random random;
  final GameCubit gameCubit;
  final double pixelRatio;

  final FragmentShader platformsShader;

  int counter = 0;

  @override
  Color backgroundColor() => const Color(0xFF00FF00);

  @override
  Future<void> onLoad() async {}
}
