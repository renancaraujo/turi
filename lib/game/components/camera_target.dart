import 'package:crystal_ball/game/crystal_ball.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

class CameraTarget extends PositionComponent with HasGameRef<CrystalBallGame> {
  CameraTarget()
      : super(
          position: Vector2(0, 0),
          size: Vector2.all(0),
          anchor: Anchor.center,
          priority: 0x7fffffff,
        );

  final effectController = GoodCurvedEffectController(
    0.1,
    Curves.easeInOut,
  )..setToEnd();

  late final moveEffect = MoveCameraTarget(position, effectController);

  @override
  Color get debugColor => const Color(0xFFFFFF00);

  // @override
  // bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    await add(moveEffect);
  }

  void go({
    required Vector2 to,
    Curve curve = Curves.easeInOut,
    double duration = 0.25,
    double scale = 1,
  }) {
    effectController
      ..duration = duration * 4
      ..curve = curve;

    moveEffect.go(to: to);
    // add(ScaleEffect.to(Vector2.all(scale), effectController));
  }

  @override
  void update(double dt) {
    super.update(dt);
    game.camera.viewfinder.zoom = scale.x;
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

class GoodCurvedEffectController extends DurationEffectController {
  GoodCurvedEffectController(super.duration, this.curve)
      : assert(duration > 0, 'Duration must be positive: $duration');

  Curve curve;

  @override
  double get progress => curve.transform(timer / duration);
}
