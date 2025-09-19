import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blob_simulator/blob_simulation/simulation_configuration.dart';

final simulationConfigurationProvider = NotifierProvider(
  SimulationConfigurationNotifier.new,
);

class SimulationConfigurationNotifier
    extends Notifier<SimulationConfiguration> {
  @override
  SimulationConfiguration build() => SimulationConfiguration();

  void set({
    Offset? mapSize,
    int? nbAgents,
    double? depT,
    double? ss,
    double? so,
    double? sa,
    double? ra,
  }) =>
      state = state.copyWith(
        mapSize: mapSize ?? state.mapSize,
        nbAgents: nbAgents ?? state.nbAgents,
        depT: depT ?? state.depT,
        ss: ss ?? state.ss,
        so: so ?? state.so,
        sa: sa ?? state.sa,
        ra: ra ?? state.ra,
      );

  void update(SimulationConfiguration value) => state = value;
}
