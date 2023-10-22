import 'dart:ui';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/animation.dart';

final kLogoSize = Vector2(1001, 547);

final logoAr = kLogoSize.x / kLogoSize.y;

class LogoComponent extends SpriteComponent
    with
        HasGameRef<CrystalBallGame>,
        FlameBlocListenable<GameCubit, GameState> {
  LogoComponent() : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = Sprite(game.assetsCache.logoImage);

    final w = kCameraSize.width * 0.6;

    paint.blendMode = BlendMode.lighten;

    size = Vector2(w, w / logoAr);
  }

  final effectController = CurvedEffectController(
    3,
    Curves.easeInOut,
  );

  OpacityEffect? _opacityEffect;

  @override
  void onNewState(GameState state) {
    effectController.setToStart();
    _opacityEffect?.removeFromParent();
    switch (state) {
      case GameState.initial:
        add(_opacityEffect = OpacityEffect.fadeIn(effectController));
      case GameState.starting:
        add(_opacityEffect = OpacityEffect.fadeOut(effectController));
      case GameState.playing:
      case GameState.gameOver:
    }
  }

  @override
  void renderTree(Canvas canvas) {
    if (canvas is SamplerCanvas<GroundSamplerOwner>) {
      if (canvas.pass == 1) {
        return;
      }
    }
    super.renderTree(canvas);
  }
}
