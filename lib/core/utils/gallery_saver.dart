import 'dart:io';
import 'package:flutter/services.dart';

class GallerySaver {
  static const MethodChannel _channel = MethodChannel('gallery_saver');

  static Future<bool> saveImageToGallery(String imagePath) async {
    try {
      if (Platform.isAndroid) {
        return await _saveToAndroidGallery(imagePath);
      } else if (Platform.isIOS) {
        return await _saveToIOSGallery(imagePath);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _saveToAndroidGallery(String imagePath) async {
    try {
      final result = await _channel.invokeMethod('saveImageToGallery', {
        'imagePath': imagePath,
      });
      return result == true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _saveToIOSGallery(String imagePath) async {
    try {
      final result = await _channel.invokeMethod('saveImageToGallery', {
        'imagePath': imagePath,
      });
      return result == true;
    } catch (e) {
      return false;
    }
  }
}
