import 'dart:async';
import 'dart:math';

import 'package:provider/provider.dart';
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
            BlocProvider<HighScoreCubit>(create: (_) => HighScoreCubit()),
          ],
          child: FutureBuilder(
            future: _loadAssets,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading assets: ${snapshot.error}'),
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
  CrystalBallGame getGame(int mode) => CrystalBallGame(
        mode,
        gameCubit: gameCubit,
        scoreCubit: scoreCubit,
        highScoreCubit: highScoreCubit,
        textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.white,
              fontSize: 4,
            ),
        random: random,
        assetsCache: widget.assetsCache,
        pixelRatio: 1,
      );

  late final FlameGame _game0 = getGame(0);
  late final FlameGame _game1 = getGame(1);
  late final FlameGame _game2 = getGame(2);
  late final FlameGame _game3 = getGame(3);
  late final FlameGame _game4 = getGame(4);
  late final FlameGame _game5 = getGame(5);

  late final random = Random();
  late final gameCubit = context.read<GameCubit>();
  late final scoreCubit = context.read<ScoreCubit>();
  late final highScoreCubit = context.read<HighScoreCubit>();

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  bool rotate = false;
  bool expand = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          if (!rotate) {
            rotate = true;
            expand = false;
          } else if (!expand) {
            rotate = true;
            expand = true;
          } else {
            rotate = false;
            expand = false;
          }
        });
      },
      child: ColoredBox(
        // color: const Color(0xFF393939),
        color: const Color(0xFF131314),
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity: expand ? 0 : 1,
              duration: const Duration(milliseconds: 400),
              child: PBJ(
                i: -2,
                rotate: rotate,
                child: const DynamicBackground(),
              ),
            ),
            PBJ2(
              i: -3,
              rotate: rotate,
              expand: expand,
              child: GameWidget(game: _game0),
            ),
            PBJ2(
              i: -2,
              rotate: rotate,
              expand: expand,
              child: GameWidget(game: _game1),
            ),
            PBJ2(
              i: -1,
              rotate: rotate,
              expand: expand,
              child: GameWidget(game: _game2),
            ),
            PBJ2(
              i: 0,
              rotate: rotate,
              expand: expand,
              child: GameWidget(game: _game3),
            ),
            PBJ2(
              i: 1,
              rotate: rotate,
              expand: expand,
              child: GameWidget(game: _game4),
            ),
            PBJ2(
              i: 2,
              rotate: rotate,
              expand: expand,
              child: GameWidget(game: _game5),
            ),
            AnimatedOpacity(
              opacity: expand ? 0 : 1,
              duration: const Duration(milliseconds: 400),
              child: PBJ(
                i: 1,
                rotate: rotate,
                child: const MeshVigenette(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        return AnimatedOpacity(
          opacity:
              state == GameState.playing || state == GameState.starting ? 1 : 0,
          duration: state == GameState.gameOver
              ? Duration.zero
              : const Duration(milliseconds: 400),
          child: AnimatedContainer(
            alignment: state == GameState.playing || state == GameState.starting
                ? Alignment.bottomCenter
                : const Alignment(0, 1.1),
            duration: const Duration(milliseconds: 400),
            child: Text(
              'Score: ${(context.watch<ScoreCubit>().state / 100).floor()}',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        );
      },
    );
  }
}

class HighScoreWidget extends StatelessWidget {
  const HighScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        return AnimatedOpacity(
          opacity:
              state == GameState.gameOver || state == GameState.initial ? 1 : 0,
          duration: const Duration(milliseconds: 400),
          child: AnimatedContainer(
            alignment: state == GameState.gameOver || state == GameState.initial
                ? Alignment.topCenter
                : const Alignment(0, -1.2),
            duration: const Duration(milliseconds: 400),
            child: Text(
              '''
High Score: ${(context.watch<HighScoreCubit>().state / 100).floor()}''',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        );
      },
    );
  }
}

class DynamicBackground extends StatefulWidget {
  const DynamicBackground({super.key});

  @override
  State<DynamicBackground> createState() => _DynamicBackgroundState();
}

class _DynamicBackgroundState extends State<DynamicBackground> {
  static Mesh25Data initial = Mesh25Data.fromHash('''
789ce363b4b3cbdfcb00044c7677fd568118ccf6211f9e8118ac20c2f65661069b9dfa0461bb944987d9edd9541aedaa195773d887dd8cb5b3d8ecc969df005433b7e225b75d06c33e7b1ec6d53cf66c1ea2f66cc2c9bcf64153f8edb9d6de15b0cbe89a631f1fef2a68cf93e9686ffda250c83e74f91c7bbb9cb9dc0cff19b8e418ff33583531fd6750f361fecfa01dc5fa1f682fdb7f46311df6ff4cba411cff39e42cb840623cff19c475f941acff0c3cb2ff19d8b8ff33f08bfe171414e4b03be4246737db7c130020ed3a57''')
      .setTessellation(6);

  static Mesh25Data postIntro = Mesh25Data.fromHash('''
789ce363b4dbb86022031030d9bdb62a073198ed25b66d0331584184edadc20c363b9d1a0d7ba62f9fd9edd99e5adaf37d38c161efddf0d09e65ef564efb06a09ab9152fb9ede2b8dedb9be9aee0b1677b7ed1de6de6125e7bbf8039f64e471205ec32dc9fd94735640bda33ae0eb48f5f7147c8de8b27cb3ebe43919be13f03971ce37f06ab26a6ff0c1ed399ff339897b1fe07dacbf69f514c87fd3f936e10c77f0e390b2e9018cf7f06715d7e10eb3f038fec7f0636eeff0cfca2ff05050559ed0e39c9d9cd36df04006df03efb''')
      .setTessellation(4);

  static Mesh25Data postIntro2 = Mesh25Data.fromHash('''
789c1366b4eb7e3d8f010898ec5e5b958318ccf6269bf78318ac20c2ee1de36a36bbe82d6cf64127beb3db334d94b00f92bbc561eff271897d208722a77d0350cdd520652e90627bcf26316ebb32b94ff6695d4c3cf64c7513ece3de77f0dabbbf4cb54f7e57cb07526cef90b5871fac3899659a805df63579fb0afba98276ff96c4d917e8a40bd93bcb9fb02f947715062b2ef41117b7b7dd960fe20833fc67e09263fccf60d5c4f49fc1633af37f06f332d6ff40a3d8fe338ae9b0ff67570be2f8cf2167c10512e30689f180c4784162fc2031019098e07f069d3821908428882b0662898388ff0c3cb2ff19d8b8ff33f08bfe17141464b23be42467a775a81b00a7015300''')
      .setTessellation(4);

  static Mesh25Data postIntro3 = Mesh25Data.fromHash('''
789c1366b4b3dd1fc200044c76afadca410c667b93cdfb410c561061f778d72936bba2c667f6665398d9ed19e6fdb377755dc861ef97b1d9deadd58cd3be01a8e65c42001748b1bd679318b79dc72e1efb045f251e7ba6ba09f671ef3b78eddd5fa6da27bfabe50329b677e33cc30f569ccc324dc02efb9abc7d85fd5441bb7f4be2ec0b74d285ec9de54fd817cabb0a831517fa888bdbdb6ecb0771c418fe738614328208a6ff0c710dccff19a22b59405cd6ff0c41596cff1922cad941621cff99c37338415caeff0c9ef1dc20160f88e00511fcff81960b805882204208448882083110210e22f84086fe67e091fdcfc006d4cd2ffa5f505090c9ee90939c9dd6a16e0002605f6b''')
      .setTessellation(4);

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
789c1366b4b3cbdfcb00044cf65c899e2006b37dc8876720062b88b0fdbac393cd4ee2db15dbbb0f02d8edfe2cd1b33d22c9c2611f65156f7b7f960ba77d0303831d4bcf5b6edb3f775aecfe1eeee6b1e79affdaeeffaf29bcf6895547ec19eba7f283ccb18fe8792b60e773f7bf7d6e41aca03d13bb957dc9e56421fb28c72cfbec2996c22073ec932bbf88dab53e5e06e288d933ee0f0131c4edcdb7368118c28cff41aeba0b24d81818c574d819987483381838e42c38ef32b072708124b81998f8c478809a747919d87905f9ee3230b3f1832404403a0419812c21104bf82e0313b32848420c44888388ff68988b010a00369747ee''');

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..scale(1.001)
        ..translate(-0.1, -0.1),
      child: IgnorePointer(
        child: MeshGradient(
          data: vigenette,
          showGrain: true,
        ),
      ),
    );
  }
}

class PBJ extends StatelessWidget {
  const PBJ({
    super.key,
    required this.child,
    required this.i,
    required this.rotate,
  });

  final Widget child;

  final int i;

  final bool rotate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: rotate ? 1.0 : 0.0),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOut,
          builder: (context, value, c) {
            // value  ..setEntry(3, 2, 0.0005);
            return Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..scale(0.84)
                ..setEntry(3, 2, 0.0005)
                ..rotateY(value * pi * 0.35)
                ..translate(0.0, 0.0, value * i * -600),
              child: child,
            );
          },
        ),
      ),
    );
  }
}

class PBJ2 extends StatelessWidget {
  const PBJ2({
    super.key,
    required this.child,
    required this.i,
    required this.rotate,
    required this.expand,
  });

  final Widget child;

  final int i;

  final bool expand;
  final bool rotate;

  @override
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: rotate ? 1.0 : 0.0),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOut,
          builder: (context, rotation, c) {
            return TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: expand ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeInOut,
              builder: (context, expansion, c) {
                // value  ..setEntry(3, 2, 0.0005);
                return Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.identity()
                    ..scale(0.74)
                    ..setEntry(3, 2, 0.0005)
                    ..rotateY(rotation * pi * 0.35)
                    ..translate(0.0, 0.0, expansion * i * -300),
                  child: DecoratedBox(
                    decoration:  expand ?  BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width:10.0 ,
                      ),
                    ) : BoxDecoration(),
                    child: child,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
