import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blob_simulator/pages/home/widgets/simulation_controls/simulation_controls.dart';
import 'package:blob_simulator/pages/home/widgets/simulation_viewer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [Expanded(child: SimulationViewer()), SimulationControls()],
      ),
    );
  }
}
