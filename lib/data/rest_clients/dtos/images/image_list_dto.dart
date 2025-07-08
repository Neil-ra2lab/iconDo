import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'image_list_dto.g.dart';

@JsonSerializable()
class ImageListDto extends Equatable {
  final List<String> images;

  const ImageListDto({required this.images});

  factory ImageListDto.fromUrlList(List<String> urls) {
    return ImageListDto(images: urls);
  }

  factory ImageListDto.fromJsonArray(List<dynamic> json) {
    return ImageListDto(images: json.map((e) => e.toString()).toList());
  }

  factory ImageListDto.fromJson(Map<String, dynamic> json) =>
      _$ImageListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ImageListDtoToJson(this);

  @override
  List<Object?> get props => [images];
}
