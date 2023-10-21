import 'package:crystal_ball/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';

class InputHandler extends PositionComponent
    with TapCallbacks, HasGameRef<CrystalBallGame> {
  InputHandler()
      : super(
          anchor: Anchor.center,
          size: kCameraSize.asVector2,
        );

  @override
  Future<void> onLoad() async {
    await add(
      KeyboardListenerComponent(
        keyDown: {
          LogicalKeyboardKey.space: onSpace,
        },
      ),
    );

    await add(
      KeyboardListenerComponent(
        keyDown: {
          LogicalKeyboardKey.arrowLeft: onLeftStart,
          LogicalKeyboardKey.arrowRight: onRightStart,
        },
        keyUp: {
          LogicalKeyboardKey.arrowLeft: onLeftEnd,
          LogicalKeyboardKey.arrowRight: onRightEnd,
        },
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position = game.world.cameraTarget.position;
  }

  bool onSpace(Set<LogicalKeyboardKey> logicalKeys) {
    if (game.gameCubit.state == GameState.initial) {
      game.gameCubit.startGame();
      return false;
    }
    return true;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    if (event.devicePosition.x < game.size.x / 2) {
      onLeftStart({});
    } else {
      onRightStart({});
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    if (game.gameCubit.state == GameState.initial) {
      game.gameCubit.startGame();
    }
    if (!game.gameCubit.isPlaying) return;
    if (event.devicePosition.x < game.size.x / 2) {
      onLeftEnd({});
    } else {
      onRightEnd({});
    }
  }

  double _directionalCoefficient = 0;

  double get directionalCoefficient => _directionalCoefficient;

  bool onLeftStart(Set<LogicalKeyboardKey> logicalKeys) {
    if (!game.gameCubit.isPlaying) return true;
    _directionalCoefficient = -1;
    return false;
  }

  bool onRightStart(Set<LogicalKeyboardKey> logicalKeys) {
    if (!game.gameCubit.isPlaying) return true;
    _directionalCoefficient = 1;
    return false;
  }

  bool onLeftEnd(Set<LogicalKeyboardKey> logicalKeys) {
    if (!game.gameCubit.isPlaying) return true;
    if (_directionalCoefficient < 0) {
      _directionalCoefficient = 0;
    }
    return false;
  }

  bool onRightEnd(Set<LogicalKeyboardKey> logicalKeys) {
    if (!game.gameCubit.isPlaying) return true;
    if (_directionalCoefficient > 0) {
      _directionalCoefficient = 0;
    }
    return false;
  }
}
