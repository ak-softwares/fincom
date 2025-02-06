import '../../../utils/constants/api_constants.dart';
import '../../../utils/constants/db_constants.dart';

class BrandModel {
  final int? id;
  final String? name;
  final String? slug;
  final int? parent;
  final String? description;
  final String? display;
  final String? image; // Nested image object
  final String? permalink; // Nested image object
  final int? menuOrder;
  final int? count;

  // Constructor
  BrandModel({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.parent,
    this.description,
    this.display,
    this.menuOrder,
    this.count,
    this.permalink,
  });


  // Factory method to create a Brand object from a JSON map
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    final slug = json[ProductBrandFieldName.slug] ?? '';
    final permalink = '${APIConstant.productBrandUrl + slug}/';
    return BrandModel(
      id: json[ProductBrandFieldName.id] ?? 0,
      name: json[ProductBrandFieldName.name] ?? '',
      slug: slug,
      parent: json[ProductBrandFieldName.parent] ?? 0,
      description: json[ProductBrandFieldName.description] ?? '',
      display: json[ProductBrandFieldName.display] ?? 'default',
      image: json[ProductBrandFieldName.image] != null ? json[ProductBrandFieldName.image]['src'] : '',
      menuOrder: json[ProductBrandFieldName.menuOrder] ?? 0,
      count: json[ProductBrandFieldName.count] ?? 0,
      permalink: permalink
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ProductBrandFieldName.id: id,
      ProductBrandFieldName.name: name,
      ProductBrandFieldName.slug: slug,
      ProductBrandFieldName.parent: parent,
      ProductBrandFieldName.description: description,
      ProductBrandFieldName.display: display,
      ProductBrandFieldName.image: image != null ? {'src': image} : null, // Ensuring proper JSON format
      ProductBrandFieldName.menuOrder: menuOrder,
      ProductBrandFieldName.count: count,
      ProductBrandFieldName.permalink: permalink, // Keeping permalink as it was dynamically generated
    };
  }

  // Method to convert Brand object back to JSON map
  Map<String, dynamic> toJson() {
    return {
      ProductBrandFieldName.id: id,
      ProductBrandFieldName.name: name,
      ProductBrandFieldName.slug: slug,
      ProductBrandFieldName.image: image,  // Include image URL in the JSON map
    };
  }
}
