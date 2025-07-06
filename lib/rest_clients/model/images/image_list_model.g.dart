// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageListModel _$ImageListModelFromJson(Map<String, dynamic> json) =>
    ImageListModel(
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ImageListModelToJson(ImageListModel instance) =>
    <String, dynamic>{
      'images': instance.images,
    };
