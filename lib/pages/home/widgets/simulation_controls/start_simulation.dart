import 'package:blob_simulator/notifiers/simulation_controller_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartSimulation extends ConsumerWidget {
  const StartSimulation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simulationControllerNotifier = ref.read(
      simulationControllerProvider.notifier,
    );
    final simulationState = ref.watch(simulationControllerProvider);

    return Row(
      spacing: 15,
      children: [
        if (simulationState.isRunning)
          ElevatedButton(
            onPressed: () => simulationControllerNotifier.stop(),
            child: const Text("Stop simulation"),
          )
        else
          ElevatedButton(
            onPressed: () => simulationControllerNotifier.play(),
            child: const Text("Start simulation"),
          ),
        ElevatedButton(
          onPressed: () => simulationControllerNotifier.reset(),
          child: const Text("Reset simulation"),
        ),
      ],
    );
  }
}
