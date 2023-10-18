import 'package:crystal_ball/game/constants.dart';
import 'package:crystal_ball/game/crystal_ball.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

class CameraTarget extends PositionComponent with HasGameRef<CrystalBallGame> {
  CameraTarget()
      : super(
          position: Vector2(0.0, -kCameraSize.height / 4),
          size: Vector2.all(1),
          anchor: Anchor.center,
          priority: 0x7fffffff,
        );

  final effectController = CurvedEffectController(
    0.1,
    Curves.easeInOut,
  )..setToEnd();

  late final moveEffect = MoveCameraTarget(position, effectController);

  @override
  Color get debugColor => const Color(0xFFFFFF00);

  @override
  bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    await add(moveEffect);
  }

  void go({required Vector2 to, bool calm = false}) {
    effectController.duration = calm ? 10 : 0.5;

    moveEffect.go(to: to);
  }
}

class MoveCameraTarget extends Effect with EffectTarget<CameraTarget> {
  MoveCameraTarget(this._to, super.controller);

  @override
  void onMount() {
    super.onMount();
    _from = target.position;
  }

  Vector2 _to;
  late Vector2 _from;

  @override
  bool get removeOnFinish => false;

  @override
  void apply(double progress) {
    final delta = _to - _from;
    final position = _from + delta * progress;
    target.position = position;
  }

  void go({required Vector2 to}) {
    reset();
    _to = to;
    _from = target.position;
  }
}
