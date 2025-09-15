import 'dart:math';

extension NumExtension on num {
  double get toRad => this * (pi / 180.0);
  double get toDegree => this * (180.0 / pi);
}
