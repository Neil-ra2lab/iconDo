import 'dart:io';
import 'package:flutter/services.dart';

class GallerySaverUtils {
  static const MethodChannel _channel = MethodChannel('gallery_saver');
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
      }
    } catch (e) {
      return false;
    }
  }
}
