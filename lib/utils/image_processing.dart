import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

Future<ui.Image> generateImageFromPixels({
  required Uint8List colouredPixels,
  required ui.Offset mapSize,
}) {
  Completer<ui.Image> completer = Completer();

  ui.decodeImageFromPixels(
    colouredPixels,
    mapSize.dx.toInt(),
    mapSize.dy.toInt(),
    ui.PixelFormat.rgba8888,
    (generatedImage) =>
        completer.complete(generatedImage as FutureOr<ui.Image>),
  );

  return completer.future;
}
