import 'dart:math';
import 'dart:ui';

class Agent {
  final Offset position;
  final double direction; // in degree

  const Agent({required this.position, required this.direction});

  Point<int> convertToContinuousCoordinates() =>
      Point(position.dx.round(), position.dy.round());

  Agent copyWith({Offset? position, double? direction}) => Agent(
    position: position ?? this.position,
    direction: direction ?? this.direction,
  );

  @override
  String toString() => "$position - $direction°";
}
