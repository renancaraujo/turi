import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

typedef CanvasCreator = Canvas Function(PictureRecorder recorder);

typedef FlameSampler = void Function(
  Image image,
  Canvas canvas,
);

class FragmentShaderLayer {
  FragmentShaderLayer({
    required this.canvasCreator,
    required this.preRender,
    required this.sampler,
    required this.shader,
    required this.pixelRatio,
  });

  final FlameSampler sampler;
  final FragmentShader shader;
  final CanvasCreator canvasCreator;
  final ValueSetter<Canvas> preRender;
  late Picture _preRenderedPicture;
  final double pixelRatio;

  void render(Canvas canvas, Vector2 size) {
    final recorder = PictureRecorder();

    final innerCanvas = canvasCreator(recorder);
    preRender(innerCanvas);
    _preRenderedPicture = recorder.endRecording();

    sampler(
      _preRenderedPicture.toImageSync(
        (pixelRatio * size.x).ceil(),
        (pixelRatio * size.y).ceil(),
      ),
      canvas,
    );
  }
}
