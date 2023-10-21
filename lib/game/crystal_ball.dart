import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:crystal_ball/game/game.dart';
import 'package:crystal_ball/gen/assets.gen.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart' show FlutterError, FlutterErrorDetails;

class CrystalBallGame extends FlameGame<CrystalWorld>
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  CrystalBallGame({
    required this.textStyle,
    required this.random,
    required this.gameCubit,
    required this.scoreCubit,
    required this.assetsCache,
    required this.pixelRatio,
  }) : super(
          world: CrystalWorld(
            random: random,
            providers: [
              FlameBlocProvider<GameCubit, GameState>.value(
                value: gameCubit,
              ),
              FlameBlocProvider<ScoreCubit, int>.value(
                value: scoreCubit,
              ),
            ],
          ),
        ) {
    images.prefix = '';

    camera.removeFromParent();

    add(cameraWithCameras);
    add(camerasWorld);

    world.addAll([
      inputHandler = InputHandler(),
    ]);
  }

  final Random random;
  final TextStyle textStyle;
  final double pixelRatio;

  final GameCubit gameCubit;
  final ScoreCubit scoreCubit;

  final AssetsCache assetsCache;

  late final InputHandler inputHandler;

  FutureOr<void> addCamera(CameraComponent component) {
    return add(component..follow(world.cameraTarget));
  }

  // cameras

  // late final classicCamera = CameraComponent.withFixedResolution(
  //   width: kCameraSize.width,
  //   height: kCameraSize.height,
  //   world: camera.world,
  // );

  late final camerasWorld = World();

  late final cameraWithCameras = SamplerCamera(
    samplerOwner: GroundSamplerOwner(
      assetsCache.groundShader,
      world: world,
      concreteTexture: assetsCache.concreteImage,
    ),
    world: camerasWorld,
    hudComponents: [
      platformGlowCamera..follow(world.cameraTarget),
      theBallGlowCamera..follow(world.cameraTarget),
    ],
    pixelRatio: pixelRatio,
  );

  late final platformGlowCamera = SamplerCamera.withFixedResolution(
    samplerOwner: PlatformsSamplerOwner(
      assetsCache.platformsShader,
      world,
    ),
    world: camera.world,
    width: kCameraSize.width,
    height: kCameraSize.height,
    pixelRatio: pixelRatio,
  );

  late final theBallGlowCamera = SamplerCamera.withFixedResolution(
    samplerOwner: TheBallSamplerOwner(
      assetsCache.theBallShader,
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

class AssetsCache {
  AssetsCache({
    required this.concreteImage,
    required this.platformsShader,
    required this.theBallShader,
    required this.groundShader,
  }) : super();

  static Future<AssetsCache> loadAll() async {
    final [concrete] = await Future.wait([
      _loadImage(Assets.images.concrete.keyName),
    ]);

    final [
      platformsShader,
      theBallShader,
      groundShader,
    ] = await Future.wait([
      _loadShader('shaders/platforms.glsl'),
      _loadShader('shaders/the_ball.glsl'),
      _loadShader('shaders/ground.glsl'),
    ]);

    return AssetsCache(
      concreteImage: concrete,
      platformsShader: platformsShader,
      theBallShader: theBallShader,
      groundShader: groundShader,
    );
  }

  static Future<Image> _loadImage(String name) async {
    final data = await Flame.bundle.load(name);
    final bytes = Uint8List.view(data.buffer);
    return decodeImageFromList(bytes);
  }

  static Future<FragmentShader> _loadShader(String name) async {
    try {
      final program = await FragmentProgram.fromAsset(name);
      return program.fragmentShader();
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(exception: error, stack: stackTrace),
      );
      rethrow;
    }
  }

  final Image concreteImage;

  final FragmentShader platformsShader;
  final FragmentShader theBallShader;
  final FragmentShader groundShader;
}
