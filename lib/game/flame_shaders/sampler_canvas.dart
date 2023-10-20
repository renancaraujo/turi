import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/components.dart';

abstract class SamplerOwner {
  SamplerOwner(this.shader, {this.passes = 1});

  final FragmentShader shader;

  final int passes;

  CameraComponent? cameraComponent;

  // ignore: use_setters_to_change_properties
  void attachCamera(CameraComponent cameraComponent) {
    this.cameraComponent = cameraComponent;
  }

  void update(double dt) {}

  void sampler(List<Image> images, Size size, Canvas canvas);
}

class SamplerCanvas<O extends SamplerOwner> implements Canvas {
  SamplerCanvas({
    required this.actualCanvas,
    required this.owner,
    required this.pass,
  });

  final Canvas actualCanvas;
  final O owner;
  final int pass;

  @override
  void clipPath(Path path, {bool doAntiAlias = true}) {
    actualCanvas.clipPath(path, doAntiAlias: doAntiAlias);
  }

  @override
  void clipRRect(RRect rrect, {bool doAntiAlias = true}) {
    return actualCanvas.clipRRect(rrect, doAntiAlias: doAntiAlias);
  }

  @override
  void clipRect(
    Rect rect, {
    ClipOp clipOp = ClipOp.intersect,
    bool doAntiAlias = true,
  }) {
    return actualCanvas.clipRect(
      rect,
      clipOp: clipOp,
      doAntiAlias: doAntiAlias,
    );
  }

  @override
  void drawArc(
    Rect rect,
    double startAngle,
    double sweepAngle,
    bool useCenter,
    Paint paint,
  ) {
    return actualCanvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      useCenter,
      paint,
    );
  }

  @override
  void drawAtlas(
    Image atlas,
    List<RSTransform> transforms,
    List<Rect> rects,
    List<Color>? colors,
    BlendMode? blendMode,
    Rect? cullRect,
    Paint paint,
  ) {
    return actualCanvas.drawAtlas(
      atlas,
      transforms,
      rects,
      colors,
      blendMode,
      cullRect,
      paint,
    );
  }

  @override
  void drawCircle(Offset c, double radius, Paint paint) {
    actualCanvas.drawCircle(c, radius, paint);
  }

  @override
  void drawColor(Color color, BlendMode blendMode) {
    actualCanvas.drawColor(color, blendMode);
  }

  @override
  void drawDRRect(RRect outer, RRect inner, Paint paint) {
    actualCanvas.drawDRRect(outer, inner, paint);
  }

  @override
  void drawImage(Image image, Offset offset, Paint paint) {
    return actualCanvas.drawImage(image, offset, paint);
  }

  @override
  void drawImageNine(Image image, Rect center, Rect dst, Paint paint) {
    return actualCanvas.drawImageNine(image, center, dst, paint);
  }

  @override
  void drawImageRect(Image image, Rect src, Rect dst, Paint paint) {
    return actualCanvas.drawImageRect(image, src, dst, paint);
  }

  @override
  void drawLine(Offset p1, Offset p2, Paint paint) {
    return actualCanvas.drawLine(p1, p2, paint);
  }

  @override
  void drawOval(Rect rect, Paint paint) {
    return actualCanvas.drawOval(rect, paint);
  }

  @override
  void drawPaint(Paint paint) {
    return actualCanvas.drawPaint(paint);
  }

  @override
  void drawParagraph(Paragraph paragraph, Offset offset) {
    return actualCanvas.drawParagraph(paragraph, offset);
  }

  @override
  void drawPath(Path path, Paint paint) {
    return actualCanvas.drawPath(path, paint);
  }

  @override
  void drawPicture(Picture picture) {
    return actualCanvas.drawPicture(picture);
  }

  @override
  void drawPoints(PointMode pointMode, List<Offset> points, Paint paint) {
    return actualCanvas.drawPoints(pointMode, points, paint);
  }

  @override
  void drawRRect(RRect rrect, Paint paint) {
    return actualCanvas.drawRRect(rrect, paint);
  }

  @override
  void drawRawAtlas(
    Image atlas,
    Float32List rstTransforms,
    Float32List rects,
    Int32List? colors,
    BlendMode? blendMode,
    Rect? cullRect,
    Paint paint,
  ) {
    return actualCanvas.drawRawAtlas(
      atlas,
      rstTransforms,
      rects,
      colors,
      blendMode,
      cullRect,
      paint,
    );
  }

  @override
  void drawRawPoints(PointMode pointMode, Float32List points, Paint paint) {
    return actualCanvas.drawRawPoints(pointMode, points, paint);
  }

  @override
  void drawRect(Rect rect, Paint paint) {
    return actualCanvas.drawRect(rect, paint);
  }

  @override
  void drawShadow(
    Path path,
    Color color,
    double elevation,
    bool transparentOccluder,
  ) {
    return actualCanvas.drawShadow(
      path,
      color,
      elevation,
      transparentOccluder,
    );
  }

  @override
  void drawVertices(Vertices vertices, BlendMode blendMode, Paint paint) {
    return actualCanvas.drawVertices(vertices, blendMode, paint);
  }

  @override
  Rect getDestinationClipBounds() {
    return actualCanvas.getDestinationClipBounds();
  }

  @override
  Rect getLocalClipBounds() {
    return actualCanvas.getLocalClipBounds();
  }

  @override
  int getSaveCount() {
    return actualCanvas.getSaveCount();
  }

  @override
  Float64List getTransform() {
    return actualCanvas.getTransform();
  }

  @override
  void restore() {
    return actualCanvas.restore();
  }

  @override
  void restoreToCount(int count) {
    return actualCanvas.restoreToCount(count);
  }

  @override
  void rotate(double radians) {
    return actualCanvas.rotate(radians);
  }

  @override
  void save() {
    return actualCanvas.save();
  }

  @override
  void saveLayer(Rect? bounds, Paint paint) {
    return actualCanvas.saveLayer(bounds, paint);
  }

  @override
  void scale(double sx, [double? sy]) {
    return actualCanvas.scale(sx, sy);
  }

  @override
  void skew(double sx, double sy) {
    return actualCanvas.skew(sx, sy);
  }

  @override
  void transform(Float64List matrix4) {
    return actualCanvas.transform(matrix4);
  }

  @override
  void translate(double dx, double dy) {
    return actualCanvas.translate(dx, dy);
  }
}
