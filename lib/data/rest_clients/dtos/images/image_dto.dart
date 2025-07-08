import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'image_dto.g.dart';

@JsonSerializable()
class ImageDto extends Equatable {
  final List<String> images;

  const ImageDto({required this.images});

  factory ImageDto.fromJson(Map<String, dynamic> json) =>
      _$ImageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ImageDtoToJson(this);

  @override
  List<Object?> get props => [images];
}
