import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class GallerySaver {
  static const MethodChannel _channel = MethodChannel('gallery_saver');

  /// Lưu ảnh vào gallery bằng native (ưu tiên Android)
  static Future<bool> saveImageToGallery(String imagePath) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final result = await _channel.invokeMethod('saveImageToGallery', {
          'imagePath': imagePath,
        });
        return result == true;
      } else {
        final result = await _channel.invokeMethod('saveImageToGallery', {
          'imagePath': imagePath,
        });
        return result == true;
        // Directory? picturesDir;
        // final documentsDir = await getApplicationDocumentsDirectory();
        // picturesDir = Directory('${documentsDir.path}/Pictures');
        // if (!await picturesDir.exists()) {
        //   await picturesDir.create(recursive: true);
        // }
        // final sourceFile = File(imagePath);
        // final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
        // final destinationPath = '${picturesDir.path}/$fileName';
        // await sourceFile.copy(destinationPath);
        // return true;
      }
    } catch (e) {
      return false;
    }
  }
}
