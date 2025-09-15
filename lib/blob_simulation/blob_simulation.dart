// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'dart:developer' as dev;
import 'package:blob_simulator/blob_simulation/simulation_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blob_simulator/blob_simulation/agent.dart';
import 'package:blob_simulator/utils/extensions/num_extension.dart';
import 'package:blob_simulator/utils/extensions/offset_extension.dart';
import 'package:blob_simulator/utils/extensions/point_extension.dart';


const bool kLogPerf = true;


class BlobSimulation {
  SimulationConfiguration configuration;
  late List<Agent> agents;
  late List<List<double>> traceMap;
  late List<List<bool>> agentsMap;

  BlobSimulation({this.configuration = const SimulationConfiguration()});

  void initSimulation() {
    agents = generateAgents(configuration.nbAgents);
    traceMap = initTraceMap(mapSize: configuration.mapSize);
    agentsMap = initAgentsMap(mapSize: configuration.mapSize);

    // Place first agent trace on the map
    for (int agentIndex = 0; agentIndex < agents.length; agentIndex++) {
      final pos = agents[agentIndex].position.toGridPoint();

      traceMap[pos.y][pos.x] = configuration.depT;
      agentsMap[pos.y][pos.x] = true;
    }
  }

  void motorStage() {
    final agentsRandIndexsOrder = generateRandListAgentIndexs();

    for (int selectedAgentIndex in agentsRandIndexsOrder) {
      final seletedAgent = agents[selectedAgentIndex];
      final Offset newPosition = Offset(
        seletedAgent.position.dx +
            configuration.ss * cos(seletedAgent.direction.toRad),
        seletedAgent.position.dy +
            configuration.ss * sin(seletedAgent.direction.toRad),
      );
      final newCoordinates = newPosition.toGridPoint();

      // ! Position is out of map
      if (newCoordinates.isOutOfArea(configuration.mapSize)) {
        final newDirection = generateRandomAgentDirection();
        agents[selectedAgentIndex] = seletedAgent.copyWith(
          direction: newDirection,
        );
      } else if (!agentsMap[newCoordinates.y][newCoordinates.x]) {
        // ! New position is free (move)
        final prevCoordinates = seletedAgent.position.toGridPoint();
        agentsMap[prevCoordinates.y][prevCoordinates.x] = false;
        agentsMap[newCoordinates.y][newCoordinates.x] = true;
        traceMap[newCoordinates.y][newCoordinates.x] += 5;
        agents[selectedAgentIndex] = seletedAgent.copyWith(
          position: newPosition,
        );
      } else {
        // ! New position isn't free
        final newDirection = generateRandomAgentDirection();
        agents[selectedAgentIndex] = seletedAgent.copyWith(
          direction: newDirection,
        );
      }
    }
  }

  void sensoryStage() {
    final agentsRandIndexsOrder = generateRandListAgentIndexs();

    for (int selectedAgentIndex in agentsRandIndexsOrder) {
      final seletedAgent = agents[selectedAgentIndex];
      double fValue = 0;
      double flValue = 0;
      double frValue = 0;

      final fPosition =
          Offset(
            seletedAgent.position.dx +
                configuration.so * cos(seletedAgent.direction.toRad),
            seletedAgent.position.dy +
                configuration.so * sin(seletedAgent.direction.toRad),
          ).toGridPoint();
      final flPosition =
          Offset(
            seletedAgent.position.dx +
                configuration.so *
                    cos((seletedAgent.direction - configuration.sa).toRad),
            seletedAgent.position.dy +
                configuration.so *
                    sin((seletedAgent.direction - configuration.sa).toRad),
          ).toGridPoint();
      final frPosition =
          Offset(
            seletedAgent.position.dx +
                configuration.so *
                    cos((seletedAgent.direction + configuration.sa).toRad),
            seletedAgent.position.dy +
                configuration.so *
                    sin((seletedAgent.direction + configuration.sa).toRad),
          ).toGridPoint();

      if (!fPosition.isOutOfArea(configuration.mapSize)) {
        fValue = traceMap[fPosition.y][fPosition.x];
      }
      if (!flPosition.isOutOfArea(configuration.mapSize)) {
        flValue = traceMap[flPosition.y][flPosition.x];
      }
      if (!frPosition.isOutOfArea(configuration.mapSize)) {
        frValue = traceMap[frPosition.y][frPosition.x];
      }

      if (fValue > flValue && fValue > frValue) {
        continue;
      } else if (fValue < flValue && fValue < frValue) {
        final ra = Random().nextBool() ? configuration.ra : -configuration.ra;
        agents[selectedAgentIndex] = seletedAgent.copyWith(
          direction: seletedAgent.direction + ra % 360,
        );
      } else if (flValue < frValue) {
        agents[selectedAgentIndex] = seletedAgent.copyWith(
          direction: seletedAgent.direction + configuration.ra % 360,
        );
      } else if (flValue > frValue) {
        agents[selectedAgentIndex] = seletedAgent.copyWith(
          direction: seletedAgent.direction - configuration.ra % 360,
        );
      }
    }
  }

  void diffusionStage() {
    final result = traceMap.map((yRow) => yRow).toList();

    final traceMapCopy = [
      List<double>.generate(configuration.mapSize.dx.toInt() + 2, (_) => 0),
      ...traceMap.map((yRow) => [0.0, ...yRow, 0.0]).toList(),
      List<double>.generate(configuration.mapSize.dx.toInt() + 2, (_) => 0),
    ];

    for (int y = 1; y < configuration.mapSize.dy + 1; y++) {
      for (int x = 1; x < configuration.mapSize.dx + 1; x++) {
        if (agentsMap[y - 1][x - 1]) continue;

        final averageValue =
            (traceMapCopy[y][x] +
                traceMapCopy[y - 1][x - 1] +
                traceMapCopy[y - 1][x] +
                traceMapCopy[y - 1][x + 1] +
                traceMapCopy[y][x - 1] +
                traceMapCopy[y][x + 1] +
                traceMapCopy[y + 1][x - 1] +
                traceMapCopy[y + 1][x] +
                traceMapCopy[y + 1][x + 1]) /
            9;
        result[y - 1][x - 1] = averageValue * 0.9;
      }
    }

    traceMap = result;
  }

  void run() {
    final total = Stopwatch()..start();

    final swMotor = Stopwatch()..start();
    dev.Timeline.timeSync('motorStage', () {
      motorStage();
    });
    swMotor.stop();

    final swSensory = Stopwatch()..start();
    dev.Timeline.timeSync('sensoryStage', () {
      sensoryStage();
    });
    swSensory.stop();

    final swDiff = Stopwatch()..start();
    dev.Timeline.timeSync('diffusionStage', () {
      diffusionStage();
    });
    swDiff.stop();

    total.stop();

    if (kLogPerf) {
      debugPrint(
        "[perf] motor=${swMotor.elapsedMilliseconds} ms, sensory=${swSensory.elapsedMilliseconds} ms, diffusion=${swDiff.elapsedMilliseconds} ms, total=${total.elapsedMilliseconds} ms",
      );
    }
  }

  List<int> generateRandListAgentIndexs() {
    return List.generate(configuration.nbAgents, (index) => index)..shuffle();
  }

  Offset generateRandomAgentPosition({required Offset mapSize}) {
    var rnd = Random();

    return Offset(
      rnd.nextDouble() * (mapSize.dx - 1),
      rnd.nextDouble() * (mapSize.dy - 1),
    );
  }

  double generateRandomAgentDirection() => Random().nextInt(361).toDouble();

  List<Agent> generateAgents(int nbAgents) {
    final result = <Agent>[];

    for (int i = 0; i < nbAgents; i++) {
      result.add(
        Agent(
          position: generateRandomAgentPosition(mapSize: configuration.mapSize),
          direction: generateRandomAgentDirection(),
        ),
      );
    }

    return result;
  }

  Uint8List generatePixelsList() {
    final List<int> result = [];

    for (int y = 0; y < configuration.mapSize.dy; y++) {
      for (int x = 0; x < configuration.mapSize.dx; x++) {
        if (traceMap[y][x] >= configuration.depT) {
          result.addAll([0, 0, 0, 255]);
        } else {
          final pixelColor = traceMap[y][x] * 255 / configuration.depT;
          result.addAll([0, 0, 0, pixelColor.toInt()]);
        }
      }
    }

    return Uint8List.fromList(result);
  }

  List<List<double>> initTraceMap({required Offset mapSize}) {
    final List<double> row = [for (int x = 0; x < mapSize.dx; x++) 0];

    return [for (int y = 0; y < mapSize.dy; y++) row.toList()];
  }

  List<List<bool>> initAgentsMap({required Offset mapSize}) {
    final List<bool> row = [for (int x = 0; x < mapSize.dx; x++) false];

    return [for (int y = 0; y < mapSize.dy; y++) row.toList()];
  }

  void printAgents() {
    agents.forEach((agent) => print(agent));
  }

  void printTraceMap() {
    for (int y = 0; y < configuration.mapSize.dy; y++) {
      print("${y} ${traceMap[y].map((x) => x.toStringAsFixed(2))}");
    }
  }
}
