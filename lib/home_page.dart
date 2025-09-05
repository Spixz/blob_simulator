import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:blob_simulator/class/blob_simulation.dart';
import 'package:blob_simulator/utils/num_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<ui.Image> generateImageFromPixels({
  required Uint8List colouredPixels,
  required Offset mapSize,
}) {
  Completer<ui.Image> completer = Completer();

  ui.decodeImageFromPixels(
    colouredPixels,
    mapSize.dx.toInt(),
    mapSize.dy.toInt(),
    ui.PixelFormat.rgba8888,
    (generatedImage) {
      completer.complete(generatedImage as FutureOr<ui.Image>);
    },
  );

  return completer.future;
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ui.Image? myImage;
  BlobSimulation simulation = BlobSimulation();
  Timer? simTimer;

  void generateImage() async {
    final image = await generateImageFromPixels(
      colouredPixels: simulation.generatePixelsList(),
      mapSize: simulation.configuration.mapSize,
    );
    print(image);

    setState(() {
      myImage = image;
    });
  }

  void startSimulation() {
    simTimer = Timer.periodic(Duration(milliseconds: 30), (_) {
      simulation.run();
      generateImage();
    });
  }

  void stopSimulation() {
    simTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // final first = Offset(1, 1);
    // print(first.distance);
    // print(first.direction.toDegree);

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (myImage != null)
                    Expanded(child: RawImage(image: myImage)),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 200,
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    simulation.initSimulation();
                    generateImage();
                  },
                  child: Text("Init simulation"),
                ),
                TextButton(
                  onPressed: () {
                    simulation.run();
                    generateImage();
                  },
                  child: Text("Make a step"),
                ),
                TextButton(
                  onPressed: () => startSimulation(),
                  child: Text("Play simulation"),
                ),
                TextButton(
                  onPressed: () => stopSimulation(),
                  child: Text("Stop simulation"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
