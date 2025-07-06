package com.example.icondo

import android.content.ContentValues
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.OutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "gallery_saver"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveImageToGallery" -> {
                    val imagePath = call.argument<String>("imagePath")
                    if (imagePath != null) {
                        val success = saveImageToGallery(imagePath)
                        result.success(success)
                    } else {
                        result.error("INVALID_ARGUMENT", "Image path is null", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun saveImageToGallery(imagePath: String): Boolean {
        return try {
            val file = File(imagePath)
            if (!file.exists()) {
                return false
            }

            val bitmap = BitmapFactory.decodeFile(file.absolutePath)
            if (bitmap == null) {
                return false
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                // Android 10+ (API 29+)
                saveImageToGalleryModern(bitmap)
            } else {
                // Android 9 and below
                saveImageToGalleryLegacy(bitmap)
            }
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun saveImageToGalleryModern(bitmap: Bitmap) {
        val contentValues = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, "image_${System.currentTimeMillis()}.png")
            put(MediaStore.MediaColumns.MIME_TYPE, "image/png")
            put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_PICTURES)
        }

        val uri = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)
        uri?.let { imageUri ->
            contentResolver.openOutputStream(imageUri)?.use { outputStream ->
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
            }
        }
    }

    private fun saveImageToGalleryLegacy(bitmap: Bitmap) {
        val picturesDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
        val imageFile = File(picturesDir, "image_${System.currentTimeMillis()}.png")
        
        FileOutputStream(imageFile).use { outputStream ->
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
        }

        // Notify gallery about new image
        val contentValues = ContentValues().apply {
            put(MediaStore.Images.Media.DATA, imageFile.absolutePath)
            put(MediaStore.Images.Media.MIME_TYPE, "image/png")
        }
        contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)
    }
}
