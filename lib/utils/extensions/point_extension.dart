import 'dart:math';
import 'dart:ui';

extension PointExtension on Point {
  bool isOutOfArea(Offset areaSize) {
    return x < 0 || x > areaSize.dx - 1 || y < 0 || y > areaSize.dy - 1;
  }
}
