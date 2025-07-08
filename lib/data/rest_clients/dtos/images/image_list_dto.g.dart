// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageListDto _$ImageListDtoFromJson(Map<String, dynamic> json) => ImageListDto(
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ImageListDtoToJson(ImageListDto instance) =>
    <String, dynamic>{
      'images': instance.images,
    };
