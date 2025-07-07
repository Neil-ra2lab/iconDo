import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icondo/services/image_download_service.dart';
import 'package:icondo/core/utils/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'detail_event.dart';
import 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc() : super(DetailInitial()) {
    on<DownloadImage>(_onDownloadImage);
  }

  Future<void> _onDownloadImage(
    DownloadImage event,
    Emitter<DetailState> emit,
  ) async {
    emit(DetailDownloading());

    try {
      final tempFilePath = await ImageDownloadService.downloadAndResizeImage(
        event.imageUrl,
      );

      if (tempFilePath == null) {
        emit(DetailError('Failed to process image'));
        return;
      }
      final documentsDir = await getApplicationDocumentsDirectory();
      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
      final finalFilePath = '${documentsDir.path}/$fileName';
      final tempFile = File(tempFilePath);
      if (!await tempFile.exists()) {
        emit(DetailError('Temp file not found'));
        return;
      }

      await tempFile.copy(finalFilePath);
      await tempFile.delete();
      final galleryResult = await GallerySaver.saveImageToGallery(
        finalFilePath,
      );

      if (galleryResult) {
        emit(DetailDownloadSuccess());
      } else {
        emit(DetailError('Failed to save to gallery'));
      }
    } catch (e) {
      emit(DetailError(e.toString()));
    }
  }
}
