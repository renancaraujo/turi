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
      sampler: samplerOwner.sampler,
      pixelRatio: pixelRatio,
    );
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

  Canvas _createCanvas(PictureRecorder recorder) {
    return SamplerCanvas(
      owner: samplerOwner,
      actualCanvas: Canvas(recorder),
    );
  }

  void _preRender(Canvas canvas) {
    super.renderTree(canvas);
  }

  @override
  void renderTree(Canvas canvas) {
    layer.render(canvas, viewport.size.toSize());
  }
}

class RenderOnlyOnSamplerCanvas<OwnerType extends SamplerOwner>
    extends Component {
  RenderOnlyOnSamplerCanvas({
    super.children,
    super.priority,
    super.key,
    this.skipNormalRendering = true,
  });

  final bool skipNormalRendering;

  @override
  void renderTree(Canvas canvas) {
    if (canvas is SamplerCanvas) {
      if (canvas.owner is! OwnerType) {
        return;
      }
    } else if (skipNormalRendering) {
      return;
    }

    super.renderTree(canvas);
  }
}

class HideForSamplerCanvas<OwnerType extends SamplerOwner> extends Component {
  HideForSamplerCanvas({
    super.children,
    super.priority,
    super.key,
  });

  @override
  void renderTree(Canvas canvas) {
    if (canvas is SamplerCanvas && canvas.owner is OwnerType) {
      return;
    }

    super.renderTree(canvas);
  }
}
