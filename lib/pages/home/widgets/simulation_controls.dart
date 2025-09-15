import 'package:blob_simulator/notifiers/simulation_configuration_notifier.dart';
import 'package:blob_simulator/notifiers/simulation_controller_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimulationControls extends ConsumerWidget {
  const SimulationControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simulationControllerNotifier = ref.read(
      simulationControllerProvider.notifier,
    );
    final simulationConfiguration = ref.watch(simulationConfigurationProvider);

    return SizedBox(
      width: 250,
      child: Column(
        children: [
          Text("Map size"),
          Row(
            children: [
              TextFormField(
                initialValue: simulationConfiguration.mapSize.dx.toString(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Width',
                ),
                onChanged: (value) {
                  final width = double.tryParse(value);

                  if (width == null) return;
                  print(width);

                  final updatedSize = Offset(
                    width,
                    simulationConfiguration.mapSize.dy,
                  );
                  ref
                      .read(simulationConfigurationProvider.notifier)
                      .set(mapSize: updatedSize);
                },
              ),
            ],
          ),
          TextButton(
            onPressed: () => simulationControllerNotifier.play(),
            child: Text("Play simulation"),
          ),
          TextButton(
            onPressed: () => simulationControllerNotifier.stop(),
            child: Text("Stop simulation"),
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
