import 'dart:io';
import 'dart:isolate';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class ImageDownloadService {
  static final StreamController<String> _resultController =
      StreamController<String>.broadcast();
  static Stream<String> get resultStream => _resultController.stream;

  static Future<String?> downloadAndSaveInIsolate(String imageUrl) async {
    final receivePort = ReceivePort();

    try {
      await Isolate.spawn(
        _isolateDownloadAndSave,
        _DownloadAndSaveData(imageUrl, receivePort.sendPort),
      );

      final result = await receivePort.first;
      return result as String?;
    } catch (e) {
      return null;
    }
  }

  static void _isolateDownloadAndSave(_DownloadAndSaveData data) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        data.imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode != 200) {
        data.sendPort.send(null);
        return;
      }

      final bytes = Uint8List.fromList(response.data as List<int>);

      if (bytes.isEmpty) {
        data.sendPort.send(null);
        return;
      }
      final tempDir = Directory.systemTemp;
      final originalFile = File(
        '${tempDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await originalFile.writeAsBytes(bytes);

      final resizedBytes = await resizeInIsolate(bytes, 0, 0);

      final resizedFileName =
          'resized_${DateTime.now().millisecondsSinceEpoch}.png';
      final resizedPath = '${tempDir.path}/$resizedFileName';
      final resizedFile = File(resizedPath);
      await resizedFile.writeAsBytes(resizedBytes);

      await originalFile.delete();

      data.sendPort.send(resizedPath);
    } catch (e) {
      debugPrint('Error in isolate: $e');
      data.sendPort.send(null);
    }
  }
}

class _DownloadAndSaveData {
  final String imageUrl;
  final SendPort sendPort;

  _DownloadAndSaveData(this.imageUrl, this.sendPort);
}

Future<Uint8List> resizeInIsolate(
  Uint8List imageData,
  int width,
  int height,
) async {
  final receivePort = ReceivePort();
  await Isolate.spawn(_resizeIsolateEntry, [
    receivePort.sendPort,
    imageData,
    width,
    height,
  ]);
  return await receivePort.first as Uint8List;
}

void _resizeIsolateEntry(List<dynamic> args) async {
  final SendPort sendPort = args[0];
  final Uint8List imageData = args[1];
  int targetWidth = args[2];
  int targetHeight = args[3];

  try {
    final codec = await ui.instantiateImageCodec(imageData);
    final frame = await codec.getNextFrame();
    final originalImage = frame.image;

    if (targetWidth == 0 || targetHeight == 0) {
      targetWidth = (originalImage.width / 2).round();
      targetHeight = (originalImage.height / 2).round();
    }

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    final paint = ui.Paint();
    final srcRect = ui.Rect.fromLTWH(
      0,
      0,
      originalImage.width.toDouble(),
      originalImage.height.toDouble(),
    );
    final dstRect = ui.Rect.fromLTWH(
      0,
      0,
      targetWidth.toDouble(),
      targetHeight.toDouble(),
    );

    canvas.drawImageRect(originalImage, srcRect, dstRect, paint);
    final picture = recorder.endRecording();

    final resizedImage = await picture.toImage(targetWidth, targetHeight);
    final byteData = await resizedImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    sendPort.send(byteData!.buffer.asUint8List());
  } catch (e) {
    debugPrint('Error resizing image in isolate: $e');
    sendPort.send(Uint8List(0));
  }
}
