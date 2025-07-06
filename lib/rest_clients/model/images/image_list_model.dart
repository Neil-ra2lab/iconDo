import 'package:json_annotation/json_annotation.dart';

part 'image_list_model.g.dart';

@JsonSerializable()
class ImageListModel {
  final List<String> images;

  const ImageListModel({required this.images});

  // Factory constructor để tạo từ danh sách URL trực tiếp
  factory ImageListModel.fromUrlList(List<String> urls) {
    return ImageListModel(images: urls);
  }

  // Factory constructor để tạo từ JSON array trực tiếp
  factory ImageListModel.fromJsonArray(List<dynamic> json) {
    return ImageListModel(images: json.map((e) => e.toString()).toList());
  }

  // Factory constructor để tạo từ JSON object có key "images"
  factory ImageListModel.fromJson(Map<String, dynamic> json) =>
      _$ImageListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageListModelToJson(this);

  @override
  String toString() {
    return 'ImageListModel(images: $images)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImageListModel && other.images == images;
  }

  @override
  int get hashCode => images.hashCode;
}
