import 'dart:io';

class ImageModel {
  String? imageUrl;
  String? imageId;
  File? image;

  ImageModel({
    this.image,
    this.imageUrl,
    this.imageId
  });

  // Convert JSON to ImageModel
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imageUrl: json['url'] ?? '',
      imageId: json['fileId'] ?? '',
    );
  }

  // Convert ImageModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'url': imageUrl,
      'fileId': imageId,
    };
  }
}
