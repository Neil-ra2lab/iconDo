import 'dart:io';
import 'dart:isolate';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:image/image.dart' as img;

class ImageDownloadService {
  static final StreamController<String> _resultController =
      StreamController<String>.broadcast();
  static Stream<String> get resultStream => _resultController.stream;
  static Future<String?> downloadAndResizeImage(String imageUrl) async {
    try {
      final tempFilePath = await _downloadResizeAndSaveInIsolate(imageUrl);
      if (tempFilePath == null) {
        return null;
      }
      return tempFilePath;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> _downloadResizeAndSaveInIsolate(
    String imageUrl,
  ) async {
    final receivePort = ReceivePort();

    try {
      await Isolate.spawn(
        _isolateDownloadResizeAndSave,
        _DownloadResizeAndSaveData(imageUrl, receivePort.sendPort),
      );

      final result = await receivePort.first;
      return result as String?;
    } catch (e) {
      return null;
    }
  }

  static void _isolateDownloadResizeAndSave(
    _DownloadResizeAndSaveData data,
  ) async {
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

      final image = img.decodeImage(bytes);
      if (image == null) {
        data.sendPort.send(null);
        return;
      }
      final newWidth = (image.width / 2).round();
      final newHeight = (image.height / 2).round();
      final resizedImage = img.copyResize(
        image,
        width: newWidth,
        height: newHeight,
      );
      final resizedBytes = img.encodePng(resizedImage);
      final tempDir = Directory.systemTemp;
      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);

      await file.writeAsBytes(Uint8List.fromList(resizedBytes));

      data.sendPort.send(filePath);
    } catch (e) {
      data.sendPort.send(null);
    }
  }
}

class _DownloadResizeAndSaveData {
  final String imageUrl;
  final SendPort sendPort;

  _DownloadResizeAndSaveData(this.imageUrl, this.sendPort);
}
