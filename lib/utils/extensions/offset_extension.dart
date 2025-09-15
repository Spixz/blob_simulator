import 'dart:math';
import 'dart:ui';

extension OffsetExtension on Offset {
  Point<int> toGridPoint() {
    return Point(dx.round(), dy.round());
  }

  bool isOutOfArea(Offset areaSize) {
    return dx < 0 || dx > areaSize.dx - 1 || dy < 0 || dy > areaSize.dy - 1;
  }
}