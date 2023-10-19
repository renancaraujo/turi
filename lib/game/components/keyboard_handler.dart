import 'package:crystal_ball/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/services.dart';

class KeyboardHandlerSync extends Component
    with FlameBlocReader<GameCubit, GameState> {
  KeyboardHandlerSync();

  @override
  Future<void> onLoad() async {
    await add(KeyboardListenerComponent(
      keyDown: {
        LogicalKeyboardKey.space: onSpace,
      },
    ));

    return super.onLoad();
  }

  bool onSpace(Set<LogicalKeyboardKey> logicalKeys) {
    if (bloc.state == GameState.initial) {
      bloc.startGame();
      return false;
    }
    return true;
  }
}

class DirectionalController extends Component
    with FlameBlocReader<GameCubit, GameState> {
  DirectionalController();

  double _directionalCoefficient = 0;

  double get directionalCoefficient => _directionalCoefficient;

  @override
  Future<void> onLoad() async {
    await add(KeyboardListenerComponent(
      keyDown: {
        LogicalKeyboardKey.arrowLeft: onLeftStart,
        LogicalKeyboardKey.arrowRight: onRightStart,
      },
      keyUp: {
        LogicalKeyboardKey.arrowLeft: onLeftEnd,
        LogicalKeyboardKey.arrowRight: onRightEnd,
      },
    ));

    return super.onLoad();
  }

  bool onLeftStart(Set<LogicalKeyboardKey> logicalKeys) {
    if (!bloc.isPlaying) return true;
    _directionalCoefficient = -1;
    return false;
  }

  bool onRightStart(Set<LogicalKeyboardKey> logicalKeys) {
    if (!bloc.isPlaying) return true;
    _directionalCoefficient = 1;
    return false;
  }

  bool onLeftEnd(Set<LogicalKeyboardKey> logicalKeys) {
    if (!bloc.isPlaying) return true;
    if (_directionalCoefficient < 0) {
      _directionalCoefficient = 0;
    }
    return false;
  }

  bool onRightEnd(Set<LogicalKeyboardKey> logicalKeys) {
    if (!bloc.isPlaying) return true;
    if (_directionalCoefficient > 0) {
      _directionalCoefficient = 0;
    }
    return false;
  }
}
