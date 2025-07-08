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

  static Future<String?> downloadAndResizeImage(String imageUrl) async {
    try {
      final tempFilePath = await _downloadAndSaveInIsolate(imageUrl);
      if (tempFilePath == null) {
        return null;
      }

      final resizedPath = await _resizeImage(tempFilePath);
      return resizedPath ?? tempFilePath;
    } catch (e) {
      debugPrint('Error downloading image: $e');
      return null;
    }
  }

  static Future<String?> _resizeImage(String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();

      final codec = await ui.instantiateImageCodec(bytes);
      final frameInfo = await codec.getNextFrame();
      final originalImage = frameInfo.image;

      final newWidth = (originalImage.width / 2).round();
      final newHeight = (originalImage.height / 2).round();

      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      final paint = ui.Paint()..filterQuality = ui.FilterQuality.high;

      canvas.drawImageRect(
        originalImage,
        ui.Rect.fromLTWH(
          0,
          0,
          originalImage.width.toDouble(),
          originalImage.height.toDouble(),
        ),
        ui.Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble()),
        paint,
      );

      final picture = recorder.endRecording();
      final resizedImage = await picture.toImage(newWidth, newHeight);
      final resizedBytes = await resizedImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (resizedBytes != null) {
        final tempDir = Directory.systemTemp;
        final fileName = 'resized_${DateTime.now().millisecondsSinceEpoch}.png';
        final resizedPath = '${tempDir.path}/$fileName';
        final resizedFile = File(resizedPath);

        await resizedFile.writeAsBytes(resizedBytes.buffer.asUint8List());

        // Delete original file
        await file.delete();

        return resizedPath;
      }
    } catch (e) {
      debugPrint('Error resizing image: $e');
    }
    return null;
  }

  static Future<String?> _downloadAndSaveInIsolate(String imageUrl) async {
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

      // Save original image
      final tempDir = Directory.systemTemp;
      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);

      await file.writeAsBytes(bytes);
      data.sendPort.send(filePath);
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
