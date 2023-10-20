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
  }

  final TextStyle textStyle;
  final Random random;
  final GameCubit gameCubit;
  final double pixelRatio;

  final FragmentShader platformsShader;

  FutureOr<void> addCamera(CameraComponent component) {
    return add(component..follow(world.cameraTarget));
  }

  late final classicCamera = CameraComponent.withFixedResolution(
    width: kCameraSize.width,
    height: kCameraSize.height,
    world: camera.world,
    backdrop: RectangleComponent(
      paint: Paint()..color = const Color(0xFF000000),
      size: kCameraSize.asVector2,
      priority: -0x7ffffffF,
    ),
  );

  // cameras
  late final platformGlowCamera = SamplerCamera.withFixedResolution(
    samplerOwner: PlatformsSamplerOwner(
      platformsShader,
      world,
    ),
    world: camera.world,
    width: kCameraSize.width,
    height: kCameraSize.height,
    pixelRatio: pixelRatio,
    backdrop: RectangleComponent(
      paint: Paint()..color = const Color(0xFF000000),
      size: kCameraSize.asVector2,
      priority: -0x7ffffffF,
    ),
  );

  int counter = 0;

  @override
  Color backgroundColor() => const Color(0xFF474747);

  @override
  Future<void> onLoad() async {}
}
