import 'package:blob_simulator/notifiers/simulation_configuration_notifier.dart';
import 'package:blob_simulator/pages/home/widgets/simulation_controls/numeric_textform_field.dart';
import 'package:blob_simulator/pages/home/widgets/simulation_controls/parameter_title.dart';
import 'package:blob_simulator/pages/home/widgets/simulation_controls/start_simulation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimulationControls extends ConsumerWidget {
  const SimulationControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(simulationConfigurationProvider);

    return Container(
      width: 370,
      decoration: BoxDecoration(color: Colors.yellow.shade200),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _mapSize(ref),
                  _numberOfAgents(ref),
                  _chemoattractantDeposit(ref),
                  _distancePerAgent(ref),
                  _sensorOffset(ref),
                  _sensorAngle(ref),
                  _rotationAgentAngle(ref),
                ],
              ),
            ),
            const StartSimulation(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _mapSize(WidgetRef ref) {
    final simulationConfiguration = ref.read(simulationConfigurationProvider);

    return Column(
      children: [
        ParameterTitle("Map size (width, height)"),
        Row(
          children: [
            Expanded(
              child: NumericTextFormField(
                initialValue: simulationConfiguration.mapSize.dx.toInt(),
                onFieldSubmitted: (value) {
                  final width = int.tryParse(value.trim());

                  if (width == null || width == 0) return;

                  final updatedSize = Offset(
                    width.toDouble(),
                    simulationConfiguration.mapSize.dy,
                  );
                  ref
                      .read(simulationConfigurationProvider.notifier)
                      .set(mapSize: updatedSize);
                },
              ),
            ),
            Expanded(
              child: NumericTextFormField(
                initialValue: simulationConfiguration.mapSize.dy.toInt(),
                onFieldSubmitted: (value) {
                  final height = int.tryParse(value.trim());

                  if (height == null || height == 0) return;

                  final updatedSize = Offset(
                    simulationConfiguration.mapSize.dx,
                    height.toDouble(),
                  );
                  ref
                      .read(simulationConfigurationProvider.notifier)
                      .set(mapSize: updatedSize);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _numberOfAgents(WidgetRef ref) {
    final simulationConfiguration = ref.read(simulationConfigurationProvider);

    return Column(
      children: [
        ParameterTitle("Number of agents", fontSize: 15),
        Container(
          child: NumericTextFormField(
            initialValue: simulationConfiguration.nbAgents,
            onFieldSubmitted: (value) {
              final nbAgents = int.tryParse(value.trim());

              if (nbAgents == null || nbAgents < 1) return;
              ref
                  .read(simulationConfigurationProvider.notifier)
                  .set(nbAgents: nbAgents);
            },
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _chemoattractantDeposit(WidgetRef ref) {
    final simulationConfiguration = ref.read(simulationConfigurationProvider);

    return Column(
      children: [
        ParameterTitle("Chemoattractant deposit per step (depT)", fontSize: 15),
        Container(
          child: NumericTextFormField(
            initialValue: simulationConfiguration.depT,
            onFieldSubmitted: (value) {
              final depT = double.tryParse(value.trim());

              if (depT == null || depT <= 0) return;
              ref
                  .read(simulationConfigurationProvider.notifier)
                  .set(depT: depT);
            },
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _distancePerAgent(WidgetRef ref) {
    final simulationConfiguration = ref.read(simulationConfigurationProvider);

    return Column(
      children: [
        ParameterTitle("Distance per agent step in pixel (ss)", fontSize: 15),
        Container(
          child: NumericTextFormField(
            initialValue: simulationConfiguration.ss,
            onFieldSubmitted: (value) {
              final ss = double.tryParse(value.trim());

              if (ss == null || ss < 1) return;
              ref.read(simulationConfigurationProvider.notifier).set(ss: ss);
            },
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _sensorOffset(WidgetRef ref) {
    final simulationConfiguration = ref.read(simulationConfigurationProvider);

    return Column(
      children: [
        ParameterTitle("Sensor offset distance (so)", fontSize: 15),
        Container(
          child: NumericTextFormField(
            initialValue: simulationConfiguration.so,
            onFieldSubmitted: (value) {
              final so = double.tryParse(value.trim());

              if (so == null || so < 1) return;
              ref.read(simulationConfigurationProvider.notifier).set(so: so);
            },
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _sensorAngle(WidgetRef ref) {
    final simulationConfiguration = ref.read(simulationConfigurationProvider);

    return Column(
      children: [
        ParameterTitle("Sensor angle for FL and FR (sa)", fontSize: 15),
        Container(
          child: NumericTextFormField(
            initialValue: simulationConfiguration.sa,
            onFieldSubmitted: (value) {
              final sa = double.tryParse(value.trim());

              if (sa == null || sa < 0 || sa > 360) return;
              ref.read(simulationConfigurationProvider.notifier).set(sa: sa);
            },
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _rotationAgentAngle(WidgetRef ref) {
    final simulationConfiguration = ref.read(simulationConfigurationProvider);

    return Column(
      children: [
        ParameterTitle("Agent rotation angle (ra)", fontSize: 15),
        Container(
          child: NumericTextFormField(
            initialValue: simulationConfiguration.ra,
            onFieldSubmitted: (value) {
              final ra = double.tryParse(value.trim());

              if (ra == null || ra < 0 || ra > 360) return;
              ref.read(simulationConfigurationProvider.notifier).set(ra: ra);
            },
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
