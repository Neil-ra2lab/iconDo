import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icondo/common/utils/gallery_saver_utils.dart';
import 'package:icondo/data/services/image_download/image_download_service.dart';
import 'package:path_provider/path_provider.dart';

import 'image_detail_event.dart';
import 'image_detail_state.dart';

class ImageDetailBloc extends Bloc<ImageDetailEvent, ImageDetailState> {
  ImageDetailBloc() : super(ImageDetailInitial()) {
    on<DownloadImage>(_onDownloadImage);
  }

  Future<void> _onDownloadImage(
    DownloadImage event,
    Emitter<ImageDetailState> emit,
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
      final galleryResult = await GallerySaverUtils.saveImageToGallery(
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
