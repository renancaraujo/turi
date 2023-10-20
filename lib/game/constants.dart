import 'dart:math';

import 'package:flame/components.dart';

const (double, double) kCameraSize = (900, 1600);
const double kPlayerRadius = 20;
const (double, double) kPlayerSize = (kPlayerRadius * 2, kPlayerRadius * 2);

const double kOpeningDuration = 4;

const double kPlatformSpawnDuration = 0.4;
const double kPlatformVerticalInterval = 1;
const double kStartPlatformHeight = 400;
const double kMeanPlatformInterval = 370;
const double kPlatformIntervalVariation = 100;
const double kPlatformMinWidth = 120;
const double kPlatformWidthVariation = 100;
const double kPlatformHeight = 10;
const double kPlatformPreloadArea = 1600;

const double kGravity = 100;
const double kJumpVelocity = 3000;
const double kPlatforGlowDistance = 1000.0;

const double kReaperTolerance = 800;

extension TransformRec on (double, double) {
  Vector2 get asVector2 => Vector2($1, $2);

  double get width => $1;

  double get height => $2;
}

extension RandomX on Random {
  double nextDoubleAntiSmooth() {
    final normal = nextDouble();
    return _invSmoothstep(normal);
  }

  double nextVariation() {
    return nextDoubleAntiSmooth() * 2 - 1;
  }

  double nextDoubleInBetween(double min, double max) {
    return nextDoubleAntiSmooth() * (max - min) + min;
  }
}

double _invSmoothstep(double normal) {
  if (normal <= 0) return 0;
  if (normal >= 1) return 1;
  return 0.5 - sin(asin(1 - 2 * normal) / 3);
}
