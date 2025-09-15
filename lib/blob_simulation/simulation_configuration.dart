// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

class SimulationConfiguration {
  final Offset mapSize;
  final int nbAgents;
  final double depT;
  final double ss;
  final double so;
  final double sa;
  final double ra;

  const SimulationConfiguration({
    this.mapSize = const Offset(500, 500),
    this.nbAgents = 5000,
    this.depT = 5, // Chemoattractant deposit per step
    this.ss = 1, // Distance per agent step in pixel
    this.so = 9, // Sensor offset distance
    this.sa = 22.5, // Sensor angle for FL and FR
    this.ra = 45, // Agent rotation angle
  });

  int get totalPixels => mapSize.dx.toInt() * mapSize.dy.toInt();

  SimulationConfiguration copyWith({
    Offset? mapSize,
    int? nbAgents,
    double? depT,
    double? ss,
    double? so,
    double? sa,
    double? ra,
  }) {
    return SimulationConfiguration(
      mapSize: mapSize ?? this.mapSize,
      nbAgents: nbAgents ?? this.nbAgents,
      depT: depT ?? this.depT,
      ss: ss ?? this.ss,
      so: so ?? this.so,
      sa: sa ?? this.sa,
      ra: ra ?? this.ra,
    );
  }
}
