import 'package:json_annotation/json_annotation.dart';

part 'image_model.g.dart';

@JsonSerializable()
class ImageModel {
  final List<String> images;

  const ImageModel({required this.images});

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageModelToJson(this);

  @override
  String toString() {
    return 'ImageModel(images: $images)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImageModel && other.images == images;
  }

  @override
  int get hashCode => images.hashCode;
}
