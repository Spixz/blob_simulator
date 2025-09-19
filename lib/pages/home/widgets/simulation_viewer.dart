import 'package:blob_simulator/notifiers/generated_image_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimulationViewer extends ConsumerWidget {
  const SimulationViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myImage = ref.watch(generatedImageProvider);

    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          if (myImage != null) Expanded(child: RawImage(image: myImage)),
        ],
      ),
    );
  }
}
