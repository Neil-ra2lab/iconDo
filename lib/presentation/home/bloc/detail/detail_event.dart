import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object?> get props => [];
}

class DownloadImage extends DetailEvent {
  final String imageUrl;

  const DownloadImage(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}
