import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icondo/services/image_download_service.dart';
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
      await ImageDownloadService.downloadAndResizeImage(event.imageUrl);
      emit(DetailDownloadSuccess());
    } catch (e) {
      emit(DetailError(e.toString()));
    }
  }
}
