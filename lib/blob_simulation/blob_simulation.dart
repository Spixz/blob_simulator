// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'package:blob_simulator/blob_simulation/simulation_configuration.dart';
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
    for (final agent in agents) {
      final pos = agent.position.toGridPoint();

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
    final newTraceMap = traceMap.map((yRow) => yRow).toList();
    final traceMapCopy = [
      List.filled(configuration.mapSize.dx.toInt() + 2, 0.0),
      ...traceMap.map((yRow) => [0.0, ...yRow, 0.0]).toList(),
      List.filled(configuration.mapSize.dx.toInt() + 2, 0.0),
    ];

    for (int y = 1; y < configuration.mapSize.dy + 1; y++) {
      for (int x = 1; x < configuration.mapSize.dx + 1; x++) {
        final agentInCell = agentsMap[y - 1][x - 1];
        if (agentInCell) continue;

        final center = traceMapCopy[y][x];
        final top = traceMapCopy[y - 1][x];
        final bottom = traceMapCopy[y + 1][x];
        final left = traceMapCopy[y][x - 1];
        final right = traceMapCopy[y][x + 1];
        final topLeft = traceMapCopy[y - 1][x - 1];
        final topRight = traceMapCopy[y - 1][x + 1];
        final bottomLeft = traceMapCopy[y + 1][x - 1];
        final bottomRight = traceMapCopy[y + 1][x + 1];

        final averageValue =
            (center +
                top +
                bottom +
                left +
                right +
                topLeft +
                topRight +
                bottomLeft +
                bottomRight) /
            9;

        newTraceMap[y - 1][x - 1] = averageValue * 0.9;
      }
    }

    traceMap = newTraceMap;
  }

  void run() {
    motorStage();
    sensoryStage();
    diffusionStage();
  }

  List<int> generateRandListAgentIndexs() =>
      List.generate(configuration.nbAgents, (index) => index)..shuffle();

  Offset generateRandomAgentPosition({required Offset mapSize}) {
    var rnd = Random();

    return Offset(
      rnd.nextDouble() * (mapSize.dx - 1),
      rnd.nextDouble() * (mapSize.dy - 1),
    );
  }

  double generateRandomAgentDirection() => Random().nextInt(361).toDouble();

  List<Agent> generateAgents(int nbAgents) {
    return List.generate(
      nbAgents,
      (_) => Agent(
        position: generateRandomAgentPosition(mapSize: configuration.mapSize),
        direction: generateRandomAgentDirection(),
      ),
    );
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
    return List.generate(
      mapSize.dy.toInt(),
      (_) => List.filled(mapSize.dx.toInt(), 0),
    );
  }

  List<List<bool>> initAgentsMap({required Offset mapSize}) {
    return List.generate(
      mapSize.dy.toInt(),
      (_) => List.filled(mapSize.dx.toInt(), false),
    );
  }

  void printAgents() => agents.forEach(print);

  void printTraceMap() {
    for (int y = 0; y < configuration.mapSize.dy; y++) {
      print("${y} ${traceMap[y].map((x) => x.toStringAsFixed(2))}");
    }
  }
}
