import 'package:crystal_ball/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/animation.dart';

class GameStateController extends Component
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
        break;
      case GameState.starting:
        game.world.cameraTarget.go(
          to: Vector2(0, -kCameraSize.height / 4),
          curve: Curves.easeInOutCubic,
          duration: kOpeningDuration,
        );
        timer = Timer(
          kOpeningDuration,
          onTick: bloc.gameStarted,
        );
      case GameState.playing:
        break;
      case GameState.gameOver:
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
          1,
          onTick: bloc.setInitial,
        );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer?.update(dt);
  }
}
