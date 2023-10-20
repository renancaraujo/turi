import 'dart:math';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const GamePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<GameCubit>(create: (_) => GameCubit()),
          ],
          child: ShaderBuilder(
            assetKey: 'shaders/the_ball.glsl',
            (context, theBallShader, _) => ShaderBuilder(
              assetKey: 'shaders/platforms.glsl',
              (context, platformsShader, _) => GameView(
                platformsShader: platformsShader,
                theBallShader: theBallShader,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GameView extends StatefulWidget {
  const GameView({
    required this.platformsShader,
    required this.theBallShader,
    super.key,
    this.game,
  });

  final FlameGame? game;
  final FragmentShader platformsShader;
  final FragmentShader theBallShader;

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  FlameGame? _game;

  late final random = Random();
  late final gameCubit = context.read<GameCubit>();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Colors.white,
          fontSize: 4,
        );

    _game ??= widget.game ??
        CrystalBallGame(
          gameCubit: gameCubit,
          textStyle: textStyle,
          random: random,
          platformsShader: widget.platformsShader,
          theBallShader: widget.theBallShader,
          pixelRatio: MediaQuery.of(context).devicePixelRatio,
        );

    return GameWidget(
      game: _game!,
    );
  }
}
