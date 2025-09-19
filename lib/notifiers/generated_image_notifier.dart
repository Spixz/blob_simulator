import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final generatedImageProvider = NotifierProvider(GeneratedImageNotifier.new);

class GeneratedImageNotifier extends Notifier<ui.Image?> {
  @override
  ui.Image? build() => null;

  void update(ui.Image value) => state = value;
}
