import 'dart:ui';

import 'package:flutter/foundation.dart';

typedef CanvasCreator = Canvas Function(PictureRecorder recorder, int pass);

typedef FlameSampler = void Function(
  List<Image> image,
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
    required this.passes,
  });

  final FlameSampler sampler;
  final FragmentShader shader;
  final CanvasCreator canvasCreator;
  final ValueSetter<Canvas> preRender;
  final double pixelRatio;
  final int passes;

  Image _renderPass(Size size, int pass) {
    final recorder = PictureRecorder();

    final innerCanvas = canvasCreator(recorder, pass);
    preRender(innerCanvas);
    final picture = recorder.endRecording();

    return picture.toImageSync(
      (pixelRatio * size.width).ceil(),
      (pixelRatio * size.height).ceil(),
    );
  }

  void render(Canvas canvas, Size size) {
    final images = <Image>[];
    for (var i = 0; i < passes; i++) {
      images.add(_renderPass(size, i));
    }

    canvas.save();
    sampler(images, size, canvas);
    canvas.restore();
  }
}
