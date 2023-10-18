import 'package:flame/components.dart';

const (double, double) kCameraSize = (900, 1600);
const double kPlayerRadius = 50;
const (double, double) kPlayerSize = (kPlayerRadius * 2, kPlayerRadius * 2);

extension TransformRec on (double, double) {
  Vector2 get asVector2 => Vector2($1, $2);

  double get width => $1;

  double get height => $2;
}
