import 'dart:math';
import 'dart:ui';

extension NumExtension on num {
  double get toRad => this * (pi / 180.0);
  double get toDegree => this * (180.0 / pi);
}

extension OffsetExtension on Offset {
  Point<int> toContinuousCoordinates() {
    return Point(dx.round(), dy.round());
  }

  bool isOutOfArea(Offset areaSize) {
    return dx < 0 || dx > areaSize.dx - 1 || dy < 0 || dy > areaSize.dy - 1;
  }
}

extension PointExtension on Point {
  bool isOutOfArea(Offset areaSize) {
    return x < 0 || x > areaSize.dx - 1 || y < 0 || y > areaSize.dy - 1;
  }
}

extension DoubleExtension on double {
  double addDegree(double degree) {
    final result = this + degree;
    if (result < 360) return result;
    return degree % 360;
  } 
  
  double subDegree(double degree) {
    final result = this - degree;
    if (result < 0) return result;
    return degree % 360;
  } 
}