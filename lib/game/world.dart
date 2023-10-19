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
        KeyboardHandlerSync(),
        directionalController = DirectionalController(),
        reaper = Reaper(),
        HideForSamplerCanvas<PlatformsSamplerOwner>(
          children: [
            theBall = TheBall(position: Vector2.zero()),
            Ground(),
          ],
        ),
        platformsContainer = RenderOnlyOnSamplerCanvas<PlatformsSamplerOwner>(),
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

  late final RenderOnlyOnSamplerCanvas platformsContainer;

  final Random random;
}
