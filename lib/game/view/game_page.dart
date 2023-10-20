import 'dart:async';
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
              (context, platformsShader, _) {
                return GameView(
                  platformsShader: platformsShader,
                  theBallShader: theBallShader,
                );
              },
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

    return ColoredBox(
      color: Colors.black,
      child: GameWidget(
        backgroundBuilder: (context) {
          return const Center(
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: MeshBackground(),
            ),
          );
        },
        overlayBuilderMap: {
          'mesh': (context, game) {
            return const Center(
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: MeshForeground(),
              ),
            );
          },
        },
        initialActiveOverlays: ['mesh'],
        game: _game!,
      ),
    );
  }
}

class MeshBackground extends StatefulWidget {
  const MeshBackground({super.key});

  @override
  State<MeshBackground> createState() => _MeshBackgroundState();
}

class _MeshBackgroundState extends State<MeshBackground> {
  static Mesh25Data initial = Mesh25Data.fromHash('''
789ce363b4b3cbdfcb00044c7677fd568118ccf6211f9e8118ac20c2f65661069b9dfa0461bb944987d9edd9541aedaa195773d887dd8cb5b3d8ecc969df005433b7e225b75d06c33e7b1ec6d53cf66c1ea2f66cc2c9bcf64153f8edb9d6de15b0cbe89a631f1fef2a68cf93e9686ffda250c83e74f91c7bbb9cb9dc0cff19b8e418ff33583531fd6750f361fecfa01dc5fa1f682fdb7f46311df6ff4cba411cff39e42cb840623cff19c475f941acff0c3cb2ff19d8b8ff33f08bfe171414e4b13be4246737db7c130021113a5b''');

  static Mesh25Data postIntro = Mesh25Data.fromHash('''
789ce363b49b39652b031030d9bdb62a073198edb5bab5400c5610617bab3083cd4ea746c39ee9cb67767bb6a796f67c1f4e70d87b373cb467d9bb95d3be01a8666ec54b6ebb38aef7f666ba2b78ecd99e5fb4779bb984d7de2f608ebdd3914401bb0cf767f6510dd982f68cab03ede357dc11b2f7e2c9b28fef50e466f8cfc025c7f89fc1aa89e93f83c774e6ff0ce665acff81f6b2fd6714d361ffcfa41bc4f19f43ce820b24c6f39f415c971fc4facfc023fb9f818dfb3f03bfe87f4141411ebb434e7276b3cd370100f6a03e5d''');
  static Mesh25Data postIntro2 = Mesh25Data.fromHash('''
789ce363b4dbb86022031030d9bdb62a073198ed25b66d0331584184edadc20c363b9d1a0d7ba62f9fd9edd99e5adaf37d38c161efddf0d09e65ef564efb06a09ab9152fb9ede2b8dedb9be9aee0b1677b7ed1de6de6125e7bbf8039f64e471205ec32dc9fd94735640bda33ae0eb48f5f7147c8de8b27cb3ebe43919be13f03971ce37f06ab26a6ff0c1ed399ff339897b1fe07dacbf69f514c87fd3f936e10c77f0e390b2e9018cf7f06715d7e10eb3f038fec7f0636eeff0cfca2ff05050579ec0e39c9d9cd36df04006e2f3f02''');



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (BuildContext context, state) {
        return AnimatedMeshGradient(
          data: state == GameState.initial ? initial : postIntro2,
          duration: const Duration(seconds: 3),
          builder: (context, data, _) {
            return MeshGradient(
              data: data,
            );
          },
        );
      },
    );
  }
}

class MeshForeground extends StatefulWidget {
  const MeshForeground({super.key});

  @override
  State<MeshForeground> createState() => _MeshForegroundState();
}

class _MeshForegroundState extends State<MeshForeground> {
  static Mesh25Data initial = Mesh25Data.fromHash('''
789c1360b4b3cbdfcb00044c7677fd568118ccf6211f9e8118ac20c2f65661069b9dfa0461bb944987d9edd9541aedaa195773d887dd8cb5b3d8ecc969df005433b7e225b75d06c33e7b1ec6d53cf66c1ea2f66cc2c9bcf64153f8edb9d6de15b0eb30bb651f12132568cf6472c13ee1958c90bdcb030bfb8017cb45ede65f3d003242dcde7c6b138821ccf09f814b8e9181c1aa89898141cd879981413b8af53fd0256c0c8c623aec0c4cba411c0c1c72165c20316e06263e311ea0765d5e06765e417e90980003339fa820033b9f881003179f90e85da0985828a780b0f85d5e41a1ff0c3cb2ff19d8b8ff33f08bfe171414e4b13be4246737db7c1300d3373d80 ''');

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity:  1,
      child: MeshGradient(
        data: initial,
      ),
    );
  }
}
