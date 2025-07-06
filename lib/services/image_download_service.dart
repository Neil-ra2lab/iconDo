import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:icondo/core/utils/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class ImageDownloadService {
  static Future<String?> downloadAndResizeImage(String imageUrl) async {
    try {
      final bytes = await _downloadInIsolate(imageUrl);
      if (bytes == null) {
        return null;
      }
      final result = await _processImageInMainIsolate(bytes);
      return result;
    } catch (e) {
      return null;
    }
  }

  static Future<Uint8List?> _downloadInIsolate(String imageUrl) async {
    final receivePort = ReceivePort();

    await Isolate.spawn(
      _isolateDownload,
      _IsolateData(imageUrl, receivePort.sendPort),
    );

    final result = await receivePort.first;
    return result as Uint8List?;
  }

  static void _isolateDownload(_IsolateData data) async {
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
      data.sendPort.send(bytes);
    } catch (e) {
      data.sendPort.send(null);
    }
  }

  static Future<String?> _processImageInMainIsolate(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frameInfo = await codec.getNextFrame();
      final image = frameInfo.image;
      final newWidth = (image.width / 2).round();
      final newHeight = (image.height / 2).round();
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble()),
        Paint(),
      );
      final picture = recorder.endRecording();
      final resizedImage = await picture.toImage(newWidth, newHeight);
      final resizedBytes = await resizedImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final documentsDir = await getApplicationDocumentsDirectory();
      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = '${documentsDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(resizedBytes!.buffer.asUint8List());

      final galleryResult = await GallerySaver.saveImageToGallery(filePath);

      if (galleryResult) {
        return 'Gallery';
      } else {
        return filePath;
      }
    } catch (e) {
      return null;
    }
  }
}

class _IsolateData {
  final String imageUrl;
  final SendPort sendPort;

  _IsolateData(this.imageUrl, this.sendPort);
}
