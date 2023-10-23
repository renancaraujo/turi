import 'dart:math';
import 'dart:ui';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/animation.dart';

class TheBall extends PositionComponent
    with
        FlameBlocListenable<GameCubit, GameState>,
        CollisionCallbacks,
        HasGameRef<CrystalBallGame> {
  TheBall({
    required Vector2 super.position,
  }) : super(
          anchor: Anchor.center,
          priority: 100000,
          children: [
            CircleHitbox(
              radius: kPlayerRadius,
              anchor: Anchor.center,
            ),
          ],
        );

  final Vector2 velocity = Vector2.zero();

  final double _gravity = kGravity;

  late double gama = 0.1;
  double get radius => (1.0 - gama) / 3;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(glowEffect);
  }

  final effectController = GoodCurvedEffectController(
    0.4,
    Curves.easeInOut,
  )..setToEnd();
  late final glowEffect = _PlatformGamaEffect(0.1, effectController);

  void jump() {
    velocity.y = -kJumpVelocity;
  }

  @override
  void onNewState(GameState state) {
    super.onNewState(state);
    switch (state) {
      case GameState.initial:
        position = Vector2.zero();
        _glowTo(to: 0.1);
      case GameState.starting:
        position = Vector2.zero();
        _glowTo(to: 0.6, duration: kOpeningDuration);
        jump();
      case GameState.playing:
        break;
      case GameState.gameOver:
        position = Vector2.zero();
        _glowTo(to: 0.1, duration: 1);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!bloc.isPlaying) {
      velocity
        ..y = 0
        ..x = 0;
      return;
    }

    velocity.y += _gravity;
    final horzV = pow(velocity.y.abs(), 1.8) * 0.0015;
    velocity.x = game.inputHandler.directionalCoefficient * horzV;

    final maxH = kCameraSize.width / 2 - kPlayerRadius - 50;

    position += velocity * dt;
    position.x = clampDouble(x, -maxH, maxH);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (!bloc.isPlaying) return;
    if (other is Ground || other is ParentIsA<Ground>) {
      velocity.y = 0;
      position.y = 0;
      jump();
      game.world.cameraTarget.go(
        to: Vector2(0, -400),
        duration: 4,
        curve: Curves.decelerate,
      );
    }
    if (other is Platform && velocity.y > 0) {
      velocity.y = 0;
      position.y = other.topLeftPosition.y - kPlayerRadius;
      jump();
      game.world.cameraTarget.go(
        to: Vector2(0, other.topLeftPosition.y - kCameraSize.height / 2 + 300),
        duration: 10,
        curve: Curves.easeOutBack,
      );
      other.glowTo(to: 1.45, duration: 0.5);
    }

    if (other is Reaper && velocity.y > 0) {
      bloc.gameOver();
      velocity.y = 0;
    }
  }

  @override
  void renderTree(Canvas canvas) {
    if (canvas is SamplerCanvas) {
      if (canvas.owner is PlatformsSamplerOwner) {
        return;
      }
    }
    super.renderTree(canvas);
  }

  void _glowTo({
    required double to,
    Curve curve = Curves.easeInOut,
    double duration = 0.1,
  }) {
    effectController
      ..duration = duration
      ..curve = curve;

    glowEffect._change(to: to);
  }
}

class _PlatformGamaEffect extends Effect with EffectTarget<TheBall> {
  _PlatformGamaEffect(this._to, super.controller);

  @override
  void onMount() {
    super.onMount();
    _from = target.gama;
  }

  double _to;
  late double _from;

  @override
  bool get removeOnFinish => false;

  @override
  void apply(double progress) {
    final delta = _to - _from;
    final position = _from + delta * progress;
    target.gama = position;
  }

  void _change({required double to}) {
    reset();

    _to = to;
    _from = target.gama;
  }
}
