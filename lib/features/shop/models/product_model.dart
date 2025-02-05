import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../utils/constants/db_constants.dart';
import 'brand_model.dart';
import 'category_model.dart';
import 'product_attribute_model.dart';

class ProductModel {
  int id;
  String? name;
  String? mainImage;
  String? permalink;
  String? slug;
  String? dateCreated;
  String? type;
  String? status;
  bool? featured;
  String? catalogVisibility;
  String? description;
  String? shortDescription;
  String? sku;
  double? price;
  double? regularPrice;
  double? salePrice;
  String? dateOnSaleFrom;
  String? dateOnSaleTo;
  bool? onSale;
  bool? purchasable;
  int? totalSales;
  bool? virtual;
  bool? downloadable;
  String? taxStatus;
  String? taxClass;
  bool? manageStock;
  int? stockQuantity;
  String? weight;
  Map<String, dynamic>? dimensions;
  bool? shippingRequired;
  bool? shippingTaxable;
  String? shippingClass;
  int? shippingClassId;
  bool? reviewsAllowed;
  double? averageRating;
  int? ratingCount;
  List<int>? upsellIds;
  List<int>? crossSellIds;
  int? parentId;
  String? purchaseNote;
  List<BrandModel>? brands;
  List<CategoryModel>? categories;
  List<Map<String, dynamic>>? tags;
  List<Map<String, dynamic>>? images;
  String? image;
  List<ProductAttributeModel>? attributes;
  List<ProductAttributeModel>? defaultAttributes;
  List<int>? variations;
  List<int>? groupedProducts;
  int? menuOrder;
  List<int>? relatedIds;
  String? stockStatus;
  bool? isCODBlocked;

  ProductModel({
    required this.id,
    this.name,
    this.mainImage,
    this.permalink,
    this.slug,
    this.dateCreated,
    this.type,
    this.status,
    this.featured,
    this.catalogVisibility,
    this.description,
    this.shortDescription,
    this.sku,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.dateOnSaleFrom,
    this.dateOnSaleTo,
    this.onSale,
    this.purchasable,
    this.totalSales,
    this.virtual,
    this.downloadable,
    this.taxStatus,
    this.taxClass,
    this.manageStock,
    this.stockQuantity,
    this.weight,
    this.dimensions,
    this.shippingRequired,
    this.shippingTaxable,
    this.shippingClass,
    this.shippingClassId,
    this.reviewsAllowed,
    this.averageRating,
    this.ratingCount,
    this.upsellIds,
    this.crossSellIds,
    this.parentId,
    this.purchaseNote,
    this.categories,
    this.brands,
    this.tags,
    this.images,
    this.image,
    this.attributes,
    this.defaultAttributes,
    this.variations,
    this.groupedProducts,
    this.menuOrder,
    this.relatedIds,
    this.stockStatus,
    this.isCODBlocked,
  });

  // create product empty model
  static ProductModel empty() => ProductModel(id: 0);

  bool isProductAvailable() {
    // Check if the coupon provides free shipping
    return stockStatus == 'instock' && getPrice() != 0;
  }
  double getPrice() {
    if (salePrice != null && salePrice! > 0) {
      return salePrice!;
    } else {
      // If salePrice is null or <= 0, fallback to regularPrice
      return regularPrice ?? 0.0;
    }
  }

  //-- Calculate Discount Percentage
  String? calculateSalePercentage() {
    if (salePrice == null || salePrice! <= 0.0 || regularPrice == null || regularPrice! <= 0.0) {
      return null;
    }

    double percentage = ((regularPrice! - salePrice!) / regularPrice!) * 100;
    return percentage.toStringAsFixed(0);
  }

  String getAllRelatedProductsIdsAsString() {
    List<String> mergedIds = [];

    if (relatedIds != null) {
      mergedIds.addAll(relatedIds!.map((id) => id.toString()));
    }

    if (upsellIds != null) {
      mergedIds.addAll(upsellIds!.map((id) => id.toString()));
    }

    if (crossSellIds != null) {
      mergedIds.addAll(crossSellIds!.map((id) => id.toString()));
    }

    return mergedIds.join(',');
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {

    final String type = json[ProductFieldName.type] ?? '';

    // Extracting category data from the JSON
    List<CategoryModel>? categories = [CategoryModel.empty()];
    if (json.containsKey(ProductFieldName.categories) && json[ProductFieldName.categories] is List) {
      categories = (json[ProductFieldName.categories] as List).map((category) => CategoryModel.fromJson(category)).toList();
    }

    // Extracting brands data from the JSON
    List<BrandModel>? brands = [];
    if (json.containsKey(ProductFieldName.brands) && json[ProductFieldName.brands] is List) {
      brands = (json[ProductFieldName.brands] as List).map((brand) => BrandModel.fromJson(brand)).toList();
    }

    // Extracting Attribute data from the JSON
    List<ProductAttributeModel>? attributes = [];
    if (json.containsKey(ProductFieldName.attributes) && json[ProductFieldName.attributes] is List) {
      attributes = (json[ProductFieldName.attributes] as List).map((attribute) =>
        ProductAttributeModel.fromJson(attribute)).toList();
    }

    // Extracting Attribute data from the JSON
    List<ProductAttributeModel>? defaultAttributes = [];
    if (json.containsKey(ProductFieldName.defaultAttributes) && json[ProductFieldName.defaultAttributes] is List) {
      defaultAttributes = (json[ProductFieldName.defaultAttributes] as List).map((attribute) =>
          ProductAttributeModel.fromJson(attribute)).toList();
    }

    return ProductModel(
      id: json[ProductFieldName.id],
      name: json[ProductFieldName.name].replaceAll('&amp;', '&'),
      mainImage: json[ProductFieldName.images] != null && json[ProductFieldName.images].isNotEmpty
          ? json[ProductFieldName.images][0]['src'] : '',
      permalink: json[ProductFieldName.permalink] ?? '',
      slug: json[ProductFieldName.slug] ?? '',
      dateCreated: json[ProductFieldName.dateCreated] ?? '',
      type: type,
      status: json[ProductFieldName.status] ?? '',
      featured: json[ProductFieldName.featured] ?? false,
      catalogVisibility: json[ProductFieldName.catalogVisibility] ?? '',
      description: json[ProductFieldName.description] ?? '',
      shortDescription: json[ProductFieldName.shortDescription] ?? '',
      sku: json[ProductFieldName.sku] ?? '',
      price: double.tryParse(json[ProductFieldName.price] ?? '0.0'),
      salePrice: double.tryParse(json[ProductFieldName.salePrice] ?? '0.0'),
      regularPrice: double.tryParse(json[ProductFieldName.regularPrice] ?? '0.0'),
      dateOnSaleFrom: json[ProductFieldName.dateOnSaleFrom] ?? '',
      dateOnSaleTo: json[ProductFieldName.dateOnSaleTo] ?? '',
      onSale: json[ProductFieldName.onSale] ?? '',
      purchasable: json[ProductFieldName.purchasable] ?? false,
      totalSales: json[ProductFieldName.totalSales] ?? 0,
      virtual: json[ProductFieldName.virtual] ?? false,
      downloadable: json[ProductFieldName.downloadable] ?? false,
      taxStatus: json[ProductFieldName.taxStatus] ?? '',
      taxClass: json[ProductFieldName.taxClass] ?? '',
      manageStock: json[ProductFieldName.manageStock] ?? false,
      stockQuantity: json[ProductFieldName.stockQuantity] ?? 0,
      weight: json[ProductFieldName.weight] ?? '',
      dimensions: json[ProductFieldName.dimensions] != null
          ? Map<String, dynamic>.from(json[ProductFieldName.dimensions])
          : null,
      shippingRequired: json[ProductFieldName.shippingRequired] ?? false,
      shippingTaxable: json[ProductFieldName.shippingTaxable] ?? false,
      shippingClass: json[ProductFieldName.shippingClass] ?? '',
      shippingClassId: json[ProductFieldName.shippingClassId] ?? 0,
      reviewsAllowed: json[ProductFieldName.reviewsAllowed] ?? false,
      averageRating: double.tryParse(json[ProductFieldName.averageRating] ?? '0.0'),
      ratingCount: json[ProductFieldName.ratingCount] ?? 0,
      upsellIds: List<int>.from(json[ProductFieldName.upsellIds] ?? []),
      crossSellIds: List<int>.from(json[ProductFieldName.crossSellIds] ?? []),
      parentId: json[ProductFieldName.parentId] ?? 0,
      purchaseNote: json[ProductFieldName.purchaseNote] ?? '',
      tags: List<Map<String, dynamic>>.from(json[ProductFieldName.tags] ?? []),
      images: json[ProductFieldName.images] != null
          ? List<Map<String, dynamic>>.from(json[ProductFieldName.images])
          : [],
      image: json[ProductFieldName.image] != null && json[ProductFieldName.image].isNotEmpty
          ? json[ProductFieldName.image]['src'] : '',
      categories: categories,
      brands: brands,
      attributes: attributes,
      defaultAttributes: defaultAttributes,
      variations: List<int>.from(json[ProductFieldName.variations] ?? []),
      groupedProducts: List<int>.from(json[ProductFieldName.groupedProducts] ?? []),
      menuOrder: json[ProductFieldName.menuOrder],
      relatedIds: List<int>.from(json[ProductFieldName.relatedIds] ?? []),
      stockStatus: json[ProductFieldName.stockStatus] ?? '',
      isCODBlocked: (json[ProductFieldName.metaData] as List?)?.any((meta) => meta['key'] == ProductFieldName.isCODBlocked && meta['value'] == "1") ?? false,
    );
  }

  // Method to extract only the 'src' values from the images list
  List<String> get imageUrlList {
    return images?.map<String>((image) => image['src']).toList() ?? [];
  }

// json format
  toJson(){
    return{
      // ProductFieldName.sku: sku,
      // ProductFieldName.title: title,
      // ProductFieldName.mainImage: mainImage,
      // ProductFieldName.stock: stock,
      // ProductFieldName.available: available,
      // ProductFieldName.price: price,
      // ProductFieldName.images: images ?? [],
      // ProductFieldName.salePrice: salePrice,
      // ProductFieldName.isFeatured: isFeatured,
      // ProductFieldName.categoryId: categoryId,
      // ProductFieldName.brandId: brandId,
      // ProductFieldName.description: description,
      // ProductFieldName.shortDescription: shortDescription,
      // ProductFieldName.productType: productType,
      // ProductFieldName.productAttributes: productAttributes != null ? productAttributes!.map((e) => e.toJson()).toList(): [],
    };
  }

  //Map json oriented document snapshot form firebase to model
  factory ProductModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if(document.data() == null) return ProductModel.empty();
    final data = document.data()!;
    return ProductModel(
      id: int.parse(document.id),
      // title: data[ProductFieldName.title],
      // mainImage: data[ProductFieldName.mainImage],
      // price: data[ProductFieldName.price] ?? 0,
      // stock: data[ProductFieldName.stock] ?? 0,
      // available: data[ProductFieldName.available] ?? true,
      // isFeatured: data[ProductFieldName.isFeatured] ?? false,
      // salePrice: data[ProductFieldName.salePrice] ?? 0,
      // categoryId: data[ProductFieldName.categoryId] ?? '',
      // brandId: data[ProductFieldName.categoryId] ?? '',
      // description: data[ProductFieldName.description] ?? '',
      // shortDescription: data[ProductFieldName.shortDescription] ?? '',
      // productType: data[ProductFieldName.productType] ?? '',
      // images: data[ProductFieldName.images] !=null ? List<String>.from(data[ProductFieldName.images]) : [],
      // productAttributes: (data['ProductAttributes'] as List<dynamic>).map((e) => ProductAttributeModel.fromJson(e)).toList(),
    );
  }

  //Map json oriented document snapshot form firebase to model
  factory ProductModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return ProductModel(
      id: int.parse(document.id),
      // title: data[ProductFieldName.title],
      // mainImage: data[ProductFieldName.mainImage],
      // price: data[ProductFieldName.price] ?? 0,
      // stock: data[ProductFieldName.stock] ?? 0,
      // available: data[ProductFieldName.available] ?? true,
      // isFeatured: data[ProductFieldName.isFeatured] ?? false,
      // salePrice: data[ProductFieldName.salePrice] ?? 0,
      // categoryId: data[ProductFieldName.categoryId] ?? '',
      // brandId: data[ProductFieldName.categoryId] ?? '',
      // description: data[ProductFieldName.description] ?? '',
      // shortDescription: data[ProductFieldName.shortDescription] ?? '',
      // productType: data[ProductFieldName.productType] ?? '',
      // images: data[ProductFieldName.images] !=null ? List<String>.from(data[ProductFieldName.images]) : [],
      // productAttributes: (data['ProductAttributes'] as List<dynamic>).map((e) => ProductAttributeModel.fromJson(e)).toList(),
    );
  }

  // Add the copyWith method
  ProductModel copyWith({
    int? id,
    String? name,
    String? mainImage,
    List<Map<String, dynamic>>? images,
    double? regularPrice,
    double? salePrice,
    String? description,
    List<ProductAttributeModel>? defaultAttributes,
    String? type,
    List<int>? variations,
    String? stockStatus,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mainImage: mainImage ?? this.mainImage,
      images: images ?? this.images,
      regularPrice: regularPrice ?? this.regularPrice,
      salePrice: salePrice ?? this.salePrice,
      description: description ?? this.description,
      defaultAttributes: defaultAttributes ?? this.defaultAttributes,
      type: type ?? this.type,
      variations: variations ?? this.variations,
      stockStatus: stockStatus ?? this.stockStatus,
    );
  }

}

int parseDoubleToInt(dynamic value) {
  if (value == null) return 0;
  try {
    double parsedValue = double.parse(value.toString());
    return parsedValue.toInt();
  } catch (e) {
    if (kDebugMode) {
      print('Error parsing value: $e');
    }
    return 0;
  }
}