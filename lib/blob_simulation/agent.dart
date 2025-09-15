// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'dart:ui';

class Agent {
  final Offset position;
  final double direction; // in degree

  const Agent({required this.position, required this.direction});

  Point<int> convertToContinuousCoordinates() {
    return Point(position.dx.round(), position.dy.round());
  }

  @override
  String toString() => "${position} - ${direction}°";

  Agent copyWith({
    Offset? position,
    double? direction,
  }) {
    return Agent(
      position: position ?? this.position,
      direction: direction ?? this.direction,
    );
  }
}
