import 'package:equatable/equatable.dart';

abstract class ImageDetailState extends Equatable {
  const ImageDetailState();

  @override
  List<Object?> get props => [];
}

class ImageDetailInitial extends ImageDetailState {}

class DetailDownloading extends ImageDetailState {}

class DetailDownloadSuccess extends ImageDetailState {}

class DetailError extends ImageDetailState {
  final String message;

  const DetailError(this.message);

  @override
  List<Object?> get props => [message];
}
