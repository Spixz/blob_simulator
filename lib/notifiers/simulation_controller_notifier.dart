import 'dart:async';
import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:blob_simulator/blob_simulation/blob_simulation.dart';
import 'package:blob_simulator/notifiers/generated_image_notifier.dart';
import 'package:blob_simulator/notifiers/simulation_configuration_notifier.dart';
import 'package:blob_simulator/utils/image_processing.dart';

final simulationControllerProvider =
    NotifierProvider<SimulationControllerNotifier, SimulationInformations>(
      () => SimulationControllerNotifier(),
    );

class SimulationControllerNotifier extends Notifier<SimulationInformations> {
  Timer? simTimer;
  BlobSimulation? simulation;
  bool simulationStepIsRunning = false;

  get isSimulationRunning => state.isRunning;

  @override
  SimulationInformations build() {
    ref.listen(simulationConfigurationProvider, (prev, conf) {
      if (prev == null) return;

      if (conf.mapSize != prev.mapSize || conf.nbAgents != prev.nbAgents) {
        final simulationWasRunning = isSimulationRunning;

        if (isSimulationRunning) this.stop();
        simulation = BlobSimulation(configuration: conf);
        simulation!.initSimulation();
        if (simulationWasRunning) {
          this.play();
        } else {
          simulationRun();
        }
        ;
      }
      simulation?.configuration = conf;
    });

    final simulationConfiguration = ref.read(simulationConfigurationProvider);
    simulation = BlobSimulation(configuration: simulationConfiguration);
    simulation!.initSimulation();
    simulationRun();
    return SimulationInformations(isRunning: false);
  }

  void play() {
    state = state.copyWith(isRunning: true);
    simTimer = Timer.periodic(Duration(milliseconds: 10), (_) async {
      simulationRun();
    });
  }

  void simulationRun() async {
    if (simulationStepIsRunning) return;

    simulationStepIsRunning = true;
    simulation?.run();

    final pixels = await Isolate.run(simulation!.generatePixelsList);
    final image = await generateImageFromPixels(
      colouredPixels: pixels,
      mapSize: ref.read(simulationConfigurationProvider).mapSize,
    );

    ref.read(generatedImageProvider.notifier).update(image);
    simulationStepIsRunning = false;
  }

  void stop() {
    simTimer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    this.stop();
    Timer(Duration(milliseconds: 300), () => ref.invalidateSelf());
  }

}

class SimulationInformations {
  final bool isRunning;

  SimulationInformations({required this.isRunning});

  SimulationInformations copyWith({bool? isRunning}) {
    return SimulationInformations(isRunning: isRunning ?? this.isRunning);
  }
}
