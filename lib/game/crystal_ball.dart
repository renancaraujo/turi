import 'dart:async';
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
    required this.theBallShader,
    required this.pixelRatio,
  }) : super(
          world: CrystalWorld(
            random: random,
            providers: [
              FlameBlocProvider<GameCubit, GameState>.value(
                value: gameCubit,
              ),
            ],
          ),
        ) {
    images.prefix = '';
    camera.removeFromParent();

    addCamera(classicCamera);
    addCamera(platformGlowCamera);
    addCamera(theBallGlowCamera);

    world.addAll([
      directionalController = KeyboardHandlerSync(),
    ]);
  }

  final TextStyle textStyle;
  final Random random;
  final GameCubit gameCubit;
  final double pixelRatio;

  late final KeyboardHandlerSync directionalController;

  final FragmentShader platformsShader;
  final FragmentShader theBallShader;

  FutureOr<void> addCamera(CameraComponent component) {
    return add(component..follow(world.cameraTarget));
  }

  // cameras

  late final classicCamera = CameraComponent.withFixedResolution(
    width: kCameraSize.width,
    height: kCameraSize.height,
    world: camera.world,
  );

  late final platformGlowCamera = SamplerCamera.withFixedResolution(
    samplerOwner: PlatformsSamplerOwner(
      platformsShader,
      world,
    ),
    world: camera.world,
    width: kCameraSize.width,
    height: kCameraSize.height,
    pixelRatio: pixelRatio,
  );

  late final theBallGlowCamera = SamplerCamera.withFixedResolution(
    samplerOwner: TheBallSamplerOwner(
      theBallShader,
      world,
    ),
    world: camera.world,
    width: kCameraSize.width,
    height: kCameraSize.height,
    pixelRatio: pixelRatio,
  );

  int counter = 0;

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {}
}
