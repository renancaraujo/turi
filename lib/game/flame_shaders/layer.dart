import 'dart:ui';

import 'package:flutter/foundation.dart';

typedef CanvasCreator = Canvas Function(PictureRecorder recorder);

typedef FlameSampler = void Function(
  Image image,
  Size size,
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

  void render(Canvas canvas, Size size) {
    final recorder = PictureRecorder();

    final innerCanvas = canvasCreator(recorder);
    preRender(innerCanvas);
    _preRenderedPicture = recorder.endRecording();

    sampler(
      _preRenderedPicture.toImageSync(
        (pixelRatio * size.width).ceil(),
        (pixelRatio * size.height).ceil(),
      ),
      size,
      canvas,
    );
  }
}
