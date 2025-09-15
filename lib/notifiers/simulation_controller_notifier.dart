import 'dart:async';
import 'dart:isolate';

import 'package:blob_simulator/blob_simulation/blob_simulation.dart';
import 'package:blob_simulator/notifiers/generated_image_notifier.dart';
import 'package:blob_simulator/notifiers/simulation_configuration_notifier.dart';
import 'package:blob_simulator/utils/image_processing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final simulationControllerProvider =
    NotifierProvider<SimulationControllerNotifier, void>(
      () => SimulationControllerNotifier(),
    );

class SimulationControllerNotifier extends Notifier<void> {
  late Timer? simTimer;
  BlobSimulation? simulation;
  bool simulationStepIsRunning = false;

  @override
  void build() {
    ref.listen(simulationConfigurationProvider, (prev, conf) {
      if (prev == null) return;

      if (conf.mapSize != prev.mapSize || conf.nbAgents != prev.nbAgents) {
        this.stop();
        simulation = BlobSimulation(configuration: conf);
        simulation!.initSimulation();
        return this.play();
      }
      simulation?.configuration = conf;
    });

    final simulationConfiguration = ref.read(simulationConfigurationProvider);
    simulation = BlobSimulation(configuration: simulationConfiguration);
    return simulation!.initSimulation();
  }

  void play() {
    simTimer = Timer.periodic(Duration(milliseconds: 10), (_) async {
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
    });
  }

  void stop() => simTimer?.cancel();
  // reset => stop + init
}

