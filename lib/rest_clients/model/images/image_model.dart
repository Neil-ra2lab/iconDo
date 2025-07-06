import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'image_model.g.dart';

@JsonSerializable()
class ImageModel extends Equatable {
  final List<String> images;

  const ImageModel({required this.images});

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageModelToJson(this);

  @override
  List<Object?> get props => [images];
}
