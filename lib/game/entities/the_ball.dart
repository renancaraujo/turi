import 'dart:ui';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
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
            _Circle(radius: kPlayerRadius),
            CircleHitbox(
              radius: kPlayerRadius,
              anchor: Anchor.center,
            ),
            // _CameraSpot(),
          ],
        );

  Vector2 _velocity = Vector2.zero();

  final double _gravity = kGravity;

  void jump() {
    _velocity.y = -kJumpVelocity;
  }

  @override
  void onNewState(GameState state) {
    super.onNewState(state);
    switch (state) {
      case GameState.initial:
      case GameState.starting:
        position = Vector2.zero();
        jump();
      case GameState.playing:
      case GameState.gameOver:
      // todo: figure out
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!bloc.isPlaying) return;

    _velocity.y += _gravity;
    final horzV = _velocity.y.abs() * 0.5;
    _velocity.x =
        game.world.directionalController.directionalCoefficient * horzV;

    final maxH = kCameraSize.width / 2 - kPlayerRadius;

    position += _velocity * dt;
    position.x = clampDouble(x, -maxH, maxH);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (!bloc.isPlaying) return;
    if (other is Ground || other is ParentIsA<Ground>) {
      _velocity.y = 0;
      position.y = 0;
      jump();
    }
    if (other is Platform && _velocity.y > 0) {
      _velocity.y = 0;
      position.y = other.topLeftPosition.y - kPlayerRadius;
      jump();
      game.world.cameraTarget.go(
        to: Vector2(0, other.topLeftPosition.y - kCameraSize.height / 2 + 100),
        duration: 2,
        curve: Curves.ease,
      );
    }

    if (other is Reaper && _velocity.y > 0) {
      bloc.gameOver();
      _velocity.y = 0;
    }
  }
}

class _Circle extends CircleComponent {
  _Circle({
    required double super.radius,
  }) : super(
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFFFFFFFF),
        );
}

// class _CameraSpot extends PositionComponent
//     with HasGameRef<CrystalBallGame>, ParentIsA<TheBall> {
//   _CameraSpot()
//       : super(
//           anchor: Anchor.center,
//         );
//
//   final timerInitial = 0.1;
//
//   GameCubit get gameCubit => parent.bloc;
//
//   late double timer = timerInitial;
//
//   @override
//   void update(double dt) {
//     if (!gameCubit.isPlaying) {
//       return;
//     }
//
//     if (timer <= 0) {
//       final distance = (absolutePosition.y - game.world.cameraTarget.position.y);
//
//       if(distance > 0) return;
//
//       print('distance $distance');
//
//       final factor = smoothStep(0, 1, distance.abs() / 400);
//
//       final duration = 3 - factor * 2.8;
//
//       game.world.cameraTarget.go(
//         to: Vector2(0, absolutePosition.y),
//         duration: duration,
//         curve: Curves.easeInCirc,
//       );
//       timer = timerInitial;
//     }
//     timer -= dt;
//   }
// }
