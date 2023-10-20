import 'dart:ui';

import 'package:crystal_ball/game/game.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

// ignore: implementation_imports
import 'package:flame/src/camera/viewports/fixed_resolution_viewport.dart';

class SamplerCamera<OwnerType extends SamplerOwner> extends CameraComponent {
  SamplerCamera({
    required this.samplerOwner,
    required this.pixelRatio,
    super.world,
    super.viewport,
    super.viewfinder,
    super.backdrop,
    super.hudComponents,
  }) {
    layer = FragmentShaderLayer(
      shader: samplerOwner.shader,
      preRender: _preRender,
      canvasCreator: _createCanvas,
      passes: samplerOwner.passes,
      sampler: samplerOwner.sampler,
      pixelRatio: pixelRatio,
    );

    samplerOwner.attachCamera(this);
  }

  factory SamplerCamera.withFixedResolution({
    required double width,
    required double height,
    required OwnerType samplerOwner,
    required double pixelRatio,
    Viewfinder? viewfinder,
    World? world,
    Component? backdrop,
    List<Component>? hudComponents,
  }) {
    return SamplerCamera(
      samplerOwner: samplerOwner,
      pixelRatio: pixelRatio,
      world: world,
      viewport: FixedResolutionViewport(resolution: Vector2(width, height))
        ..addAll(hudComponents ?? []),
      viewfinder: viewfinder ?? Viewfinder(),
      backdrop: backdrop,
    );
  }

  final OwnerType samplerOwner;

  late final FragmentShaderLayer layer;

  final double pixelRatio;

  Canvas _createCanvas(PictureRecorder recorder, int pass) {
    return SamplerCanvas(
      owner: samplerOwner,
      actualCanvas: Canvas(recorder),
      pass: pass,
    );
  }

  void _preRender(Canvas canvas) {
    super.renderTree(canvas);
  }

  @override
  void renderTree(Canvas canvas) {
    final offset = viewport.position;
    canvas
      ..save()
      ..translate(offset.x, offset.y);
    layer.render(canvas, viewport.size.toSize());
    canvas.restore();
  }

  @override
  void update(double dt) {
    super.update(dt);
    samplerOwner.update(dt);
  }
}
