import 'dart:math';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

class PlatformSpawner extends Component
    with
        HasGameRef<CrystalBallGame>,
        FlameBlocListenable<GameCubit, GameState> {
  PlatformSpawner({
    required this.random,
  });

  final Random random;

  double currentMinY = kStartPlatformHeight;

  bool needsPreloadCheck = false;

  @override
  void onLoad() {}

  Future<void> spawnPlatform() async {
    final y = currentMinY;
    final padedHalfWidth = (kCameraSize.width - 100) / 2;
    final x = random.nextDoubleInBetween(-padedHalfWidth, padedHalfWidth);

    final color = PlatformColor.random(random);

    final width = kPlatformMinWidth +
        random.nextDoubleAntiSmooth() * kPlatformWidthVariation;

    final size = Vector2(width, kPlatformHeight);

    await game.world.platformsContainer.add(
      Platform(
        position: Vector2(x, -y),
        size: size,
        color: color,
      ),
    );

    final interval = kMeanPlatformInterval +
        random.nextVariation() * kPlatformIntervalVariation;
    currentMinY += interval;
  }

  Future<void> preloadPlatforms() async {
    needsPreloadCheck = false;
    var count = 0;
    while (distanceToCameraTop < kPlatformPreloadArea && count < 10) {
      await spawnPlatform();
      count++;
    }
    needsPreloadCheck = true;
  }

  Future<void> spawnIntitialPlatforms() async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    var count = 0;
    while (distanceToCameraTop < kPlatformPreloadArea && count < 10) {
      final delayed = Future<void>.delayed(
        Duration(
          milliseconds: (kPlatformSpawnDuration * 1000).floor(),
        ),
      );
      await Future.wait<void>([spawnPlatform(), delayed]);
      count++;
    }
    needsPreloadCheck = true;
  }

  @override
  void onNewState(GameState state) {
    super.onNewState(state);
    switch (state) {
      case GameState.initial:
        needsPreloadCheck = false;
        currentMinY = kStartPlatformHeight;
      case GameState.starting:
        spawnIntitialPlatforms();
      case GameState.playing:
      case GameState.gameOver:
    }
  }

  double get cameraTop => game.world.cameraTarget.y - kCameraSize.height / 2;

  double get distanceToCameraTop => currentMinY - (-cameraTop);

  @override
  void update(double dt) {
    super.update(dt);

    if (needsPreloadCheck && distanceToCameraTop < kPlatformPreloadArea) {
      needsPreloadCheck = false;
      preloadPlatforms();
    }
  }
}
