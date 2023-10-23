import 'package:crystal_ball/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/animation.dart';

class GameStateSync extends Component
    with
        HasGameRef<CrystalBallGame>,
        FlameBlocListenable<GameCubit, GameState> {
  Timer? timer;

  @override
  void onNewState(GameState state) {
    super.onNewState(state);
    timer?.stop();
    timer = null;
    switch (state) {
      case GameState.initial:
        setScore(0);
      case GameState.starting:
        game.world.cameraTarget.go(
          to: Vector2(0, -400),
          curve: Curves.easeInOutCubic,
          duration: kOpeningDuration,
        );
        setScore(0);
        timer = Timer(
          kOpeningDuration,
          onTick: bloc.gameStarted,
        );
      case GameState.playing:
        break;
      case GameState.gameOver:
        setScore(0);
        game.world.cameraTarget.go(
          to: Vector2(0, 0),
          curve: Curves.easeInOutCubic,
          duration: 0.3,
        );
        game.world.theBall.position = Vector2.zero();
        for (final platform in game.world.getPlatforms()) {
          platform.removeFromParent();
        }
        timer = Timer(
          2,
          onTick: bloc.setInitial,
        );
    }
  }

  void setScore(int score) {
    game.scoreCubit.setScore(score);
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer?.update(dt);

    if (bloc.isPlaying) {
      final current = -game.world.theBall.position.y.floor();
      if (current > game.scoreCubit.state) {
        setScore(current);
        game.highScoreCubit.setScore(current);
      }
    }
  }
}
