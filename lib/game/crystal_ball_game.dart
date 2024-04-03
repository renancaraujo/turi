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
    with
        HasKeyboardHandlerComponents,
        HasCollisionDetection,
        SingleGameInstance {
  CrystalBallGame({
    required this.textStyle,
    required this.random,
    required this.gameCubit,
    required this.scoreCubit,
    required this.highScoreCubit,
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

    add(dummyWorld);
    world.addAll([
      inputHandler = InputHandler(),
    ]);
  }

  final Random random;
  final TextStyle textStyle;
  final double pixelRatio;

  final GameCubit gameCubit;
  final ScoreCubit scoreCubit;
  final HighScoreCubit highScoreCubit;

  final AssetsCache assetsCache;

  late final InputHandler inputHandler;

  FutureOr<void> addCamera(CameraComponent component) {
    return add(component..follow(world.cameraTarget));
  }

  final dummyWorld = World();

  late final cameraWithCameras = SamplerCamera(
    samplerOwner: GroundSamplerOwner(
      assetsCache.groundShader,
      assetsCache.rocksShader,
      assetsCache.fogShader,
      classicCamera,
      world: world,
    ),
    world: dummyWorld,
    hudComponents: [
      classicCamera..follow(world.cameraTarget),
      fogCamera..follow(world.cameraTarget),
      platformGlowCamera..follow(world.cameraTarget),
      theBallGlowCamera..follow(world.cameraTarget),
    ],
    pixelRatio: pixelRatio,
  );

  late final classicCamera = CameraComponent.withFixedResolution(
    width: kCameraSize.width,
    height: kCameraSize.height,
    world: camera.world,
  );

  late final fogCamera = SamplerCamera.withFixedResolution(
    samplerOwner: FogSamplerOwner(
      assetsCache.fogShader,
      world,
    ),
    world: camera.world,
    width: kCameraSize.width,
    height: kCameraSize.height,
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
    width: kCameraSize.width,
    height: kCameraSize.height,
    world: camera.world,
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
    // images
    required this.rocksRightImage,
    required this.rocksLeftImage,
    required this.rockBottom1Image,
    required this.bgRockBaseImage,
    required this.bgRockPillarImage,
    required this.logoImage,
    // shaders
    required this.platformsShader,
    required this.theBallShader,
    required this.groundShader,
    required this.rocksShader,
    required this.fogShader,
  });

  static Future<AssetsCache> loadAll() async {
    final [
      rocksRight,
      rocksLeft,
      rocksBottom1,
      bgrockbase,
      bgrockpillar,
      logo,
    ] = await Future.wait([
      _loadImage(Assets.images.rocksr.keyName),
      _loadImage(Assets.images.rocksl2.keyName),
      _loadImage(Assets.images.bottomRocks1.keyName),
      _loadImage(Assets.images.bgrockbase.keyName),
      _loadImage(Assets.images.bgrockpillar.keyName),
      _loadImage(Assets.images.turilogo.keyName),
    ]);

    final [
      platformsShader,
      theBallShader,
      groundShader,
      rocksShader,
      fogShader,
    ] = await Future.wait([
      _loadShader('shaders/platforms.glsl'),
      _loadShader('shaders/the_ball.glsl'),
      _loadShader('shaders/ground.glsl'),
      _loadShader('shaders/rocks.glsl'),
      _loadShader('shaders/fog.glsl'),
    ]);

    return AssetsCache(
      // images
      rocksRightImage: rocksRight,
      rocksLeftImage: rocksLeft,
      rockBottom1Image: rocksBottom1,
      bgRockBaseImage: bgrockbase,
      bgRockPillarImage: bgrockpillar,
      logoImage: logo,
      // shaders
      platformsShader: platformsShader,
      theBallShader: theBallShader,
      groundShader: groundShader,
      rocksShader: rocksShader,
      fogShader: fogShader,
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

  final Image rocksRightImage;
  final Image rocksLeftImage;
  final Image rockBottom1Image;
  final Image bgRockBaseImage;
  final Image bgRockPillarImage;
  final Image logoImage;

  final FragmentShader platformsShader;
  final FragmentShader theBallShader;
  final FragmentShader groundShader;
  final FragmentShader rocksShader;
  final FragmentShader fogShader;
}
