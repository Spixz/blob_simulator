import 'dart:ui';

class SimulationConfiguration {
  final Offset mapSize;
  final int nbAgents;
  final double depT; // Amount of chemoattractant deposited per step
  final double ss; // Distance traveled by each agent per step (in pixels)
  final double so; // Distance between the agent and its sensors
  final double sa; // Sensor angle for left and right sensors (in degrees)
  final double ra; // Rotation angle of the agent (in degrees)

  const SimulationConfiguration({
    this.mapSize = const Offset(300, 300),
    this.nbAgents = 2000,
    this.depT = 5,
    this.ss = 1,
    this.so = 9,
    this.sa = 22.5,
    this.ra = 45,
  });

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

  int get totalPixels => mapSize.dx.toInt() * mapSize.dy.toInt();
}
