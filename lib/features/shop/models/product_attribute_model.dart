import '../../../utils/constants/db_constants.dart';

class ProductAttributeModel {
  final int? id;
  final String? name;
  final String? slug;
  final int? position;
  final bool? visible;
  final bool? variation;
  final String? option;
  final List<String>? options;

  ProductAttributeModel({
    this.id,
    this.name,
    this.slug,
    this.position,
    this.visible,
    this.variation,
    this.option,
    this.options,
  });

  // Factory method to create an object from JSON
  factory ProductAttributeModel.fromJson(Map<String, dynamic> json) {
    final optionJson = json[ProductAttributeFieldName.option] ?? '';
    // Ensure optionJson is safely decoded
    String option;
    try {
      option = optionJson.isNotEmpty ? Uri.decodeFull(optionJson) : '';
    } catch (e) {
      option = optionJson; // If decoding fails, keep the original string
    }
    return ProductAttributeModel(
      id: json[ProductAttributeFieldName.id] ?? 0,
      name: json[ProductAttributeFieldName.name] ?? '',
      slug: json[ProductAttributeFieldName.slug] ?? '',
      position: json[ProductAttributeFieldName.position] ?? 0,
      visible: json[ProductAttributeFieldName.visible] ?? false,
      variation: json[ProductAttributeFieldName.variation] ?? false,
      options: json[ProductAttributeFieldName.options] is List
          ? List<String>.from(json[ProductAttributeFieldName.options])
          : [], // Ensure it's a list
      option: option,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ProductAttributeFieldName.id: id,
      ProductAttributeFieldName.name: name,
      ProductAttributeFieldName.slug: slug,
      ProductAttributeFieldName.position: position,
      ProductAttributeFieldName.visible: visible,
      ProductAttributeFieldName.variation: variation,
      ProductAttributeFieldName.option: option != null ? Uri.encodeFull(option!) : null, // Ensuring safe encoding
      ProductAttributeFieldName.options: options ?? [],
    };
  }


  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      ProductAttributeFieldName.id: id,
      ProductAttributeFieldName.name: name,
      ProductAttributeFieldName.slug: slug,
      ProductAttributeFieldName.position: position,
      ProductAttributeFieldName.visible: visible,
      ProductAttributeFieldName.variation: variation,
      ProductAttributeFieldName.options: options,
    };
  }
}