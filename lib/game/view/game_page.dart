import 'dart:async';
import 'dart:math';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const GamePage(),
    );
  }

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final Future<AssetsCache> _loadAssets = AssetsCache.loadAll();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<GameCubit>(create: (_) => GameCubit()),
            BlocProvider<ScoreCubit>(create: (_) => ScoreCubit()),
          ],
          child: FutureBuilder(
            future: _loadAssets,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading assets: ${snapshot.error}',
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final assetsCache = snapshot.data!;

              return GameView(
                assetsCache: assetsCache,
              );
            },
          ),
        ),
      ),
    );
  }
}

class GameView extends StatefulWidget {
  const GameView({
    required this.assetsCache,
    super.key,
  });

  final AssetsCache assetsCache;

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  FlameGame? _game;

  late final random = Random();
  late final gameCubit = context.read<GameCubit>();
  late final scoreCubit = context.read<ScoreCubit>();

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Colors.white,
          fontSize: 4,
        );

    _game ??= CrystalBallGame(
      gameCubit: gameCubit,
      scoreCubit: scoreCubit,
      textStyle: textStyle,
      random: random,
      assetsCache: widget.assetsCache,
      pixelRatio: 1,
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
          'vignette': (context, game) {
            return const Center(
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: MeshVigenette(),
              ),
            );
          },
        },
        initialActiveOverlays: const ['vignette'],
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
789ce363b4b3cbdfcb00044c7677fd568118ccf6211f9e8118ac20c2f65661069b9dfa0461bb944987d9edd9541aedaa195773d887dd8cb5b3d8ecc969df005433b7e225b75d06c33e7b1ec6d53cf66c1ea2f66cc2c9bcf64153f8edb9d6de15b0cbe89a631f1fef2a68cf93e9686ffda250c83e74f91c7bbb9cb9dc0cff19b8e418ff33583531fd6750f361fecfa01dc5fa1f682fdb7f46311df6ff4cba411cff39e42cb840623cff19c475f941acff0c3cb2ff19d8b8ff33f08bfe171414e4b03be4246737db7c130020ed3a57''');

  static Mesh25Data postIntro = Mesh25Data.fromHash('''
789ce363b4dbb86022031030d9bdb62a073198ed25b66d0331584184edadc20c363b9d1a0d7ba62f9fd9edd99e5adaf37d38c161efddf0d09e65ef564efb06a09ab9152fb9ede2b8dedb9be9aee0b1677b7ed1de6de6125e7bbf8039f64e471205ec32dc9fd94735640bda33ae0eb48f5f7147c8de8b27cb3ebe43919be13f03971ce37f06ab26a6ff0c1ed399ff339897b1fe07dacbf69f514c87fd3f936e10c77f0e390b2e9018cf7f06715d7e10eb3f038fec7f0636eeff0cfca2ff05050559ed0e39c9d9cd36df04006df03efb''');

  static Mesh25Data postIntro2 = Mesh25Data.fromHash('''
789c1366b4eb7e3d8f010898ec5e5b958318ccf6269bf78318ac20c2ee1de36a36bbe82d6cf64127beb3db334d94b00f92bbc561eff271897d208722a77d0350cdd520652e90627bcf26316ebb32b94ff6695d4c3cf64c7513ece3de77f0dabbbf4cb54f7e57cb07526cef90b5871fac3899659a805df63579fb0afba98276ff96c4d917e8a40bd93bcb9fb02f947715062b2ef41117b7b7dd960fe20833fc67e09263fccf60d5c4f49fc1633af37f06f332d6ff40a3d8fe338ae9b0ff67570be2f8cf2167c10512e30689f180c4784162fc2031019098e07f069d3821908428882b0662898388ff0c3cb2ff19d8b8ff33f08bfe17141464b23be42467a775a81b00a7015300''');

  static Mesh25Data postIntro3 = Mesh25Data.fromHash('''
789c1366b4b3dd1fc200044c76afadca410c667b93cdfb410c561061f778d72936bba2c667f6665398d9ed19e6fdb377755dc861ef97b1d9deadd58cd3be01a8e65c42001748b1bd679318b79dc72e1efb045f251e7ba6ba09f671ef3b78eddd5fa6da27bfabe50329b677e33cc30f569ccc324dc02efb9abc7d85fd5441bb7f4be2ec0b74d285ec9de54fd817cabb0a831517fa888bdbdb6ecb0771c418fe738614328208a6ff0c710dccff19a22b59405cd6ff0c41596cff1922cad941621cff99c37338415caeff0c9ef1dc20160f88e00511fcff81960b805882204208448882083110210e22f84086fe67e091fdcfc006d4cd2ffa5f505090c9ee90939c9dd6a16e0002605f6b''');

  Mesh25Data data = initial;

  int lastComputedScore = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GameCubit, GameState>(
          listenWhen: (previous, current) =>
              previous == GameState.initial && current == GameState.starting ||
              previous == GameState.playing,
          listener: (context, state) {
            if (state == GameState.starting) {
              setState(() {
                data = postIntro;
              });
            } else {
              setState(() {
                data = initial;
              });
            }
          },
        ),
        BlocListener<ScoreCubit, int>(
          listenWhen: (previous, current) {
            final isPlaying = context.read<GameCubit>().isPlaying;
            return isPlaying && (current - lastComputedScore).abs() > 400;
          },
          listener: (context, state) {
            lastComputedScore = state;
            if (state > 600 && state < 10000) {
              final progress = state / 9400;
              setState(() {
                data = Mesh25Data.lerp(postIntro, postIntro2, progress);
              });
            }
            if (state > 10000 && state < 100000) {
              final progress = (state - 10000) / 90000;
              setState(() {
                data = Mesh25Data.lerp(postIntro2, postIntro3, progress);
              });
            } else if (state > 100000 && data != postIntro3) {
              setState(() {
                data = postIntro3;
              });
            }
          },
        ),
      ],
      child: AnimatedMeshGradient(
        data: data,
        duration: const Duration(seconds: 1),
        builder: (context, data, _) {
          return MeshGradient(data: data);
        },
      ),
    );
  }
}

class MeshVigenette extends StatelessWidget {
  const MeshVigenette({super.key});

  static Mesh25Data vigenette = Mesh25Data.fromHash('''
789c1366b4b3cbdfcb00044cf63c1e4b400c66fb900fcf400c5610617bab3083cd4e7d82b05dcaa4c3ecf66c2a8d76d58cab39ecc36ec6da596cf6e4b46f00aa995bf192db2ee248aebdeafca73cf66c1ea2f66cc2c9bcf6011153ec959db6f183ccb18fe8792b60576076cbbef049b5a03d13bb957dc9e56421fb803f87ecf3ef440983ccb14faefc226ad7fa7819882366cfb83f04c410b737dfda04620833fc67e092636460b06a62626050f3616660d08e62fd0f349c8d81514c879d81493788838143ce820b24c6cdc0c427c603d4aecbcbc0ce2bc80f121300a913049ac020046289de05b2c440843888f8cfc023fb9f818dfb3f980df4bf3d030400003587426b''');

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.6,
        child: MeshGradient(
          data: vigenette,
        ),
      ),
    );
  }
}
