import 'package:equatable/equatable.dart';

abstract class ImageDetailEvent extends Equatable {
  const ImageDetailEvent();

  @override
  List<Object?> get props => [];
}

class DownloadImage extends ImageDetailEvent {
  final String imageUrl;

  const DownloadImage(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}
