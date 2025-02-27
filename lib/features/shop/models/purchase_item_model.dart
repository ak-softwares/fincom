class PurchaseItemModel {
  int id;
  final String image;
  String name;
  int prepaidQuantity;
  int bulkQuantity;
  int totalQuantity;
  bool isOlderThanTwoDays;

  PurchaseItemModel({
    required this.id,
    required this.image,
    this.name = '',
    this.prepaidQuantity = 0,
    this.bulkQuantity = 0,
    this.totalQuantity = 0,
    this.isOlderThanTwoDays = false,
  });

  factory PurchaseItemModel.fromJson(Map<String, dynamic> json) {
    return PurchaseItemModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      prepaidQuantity: json['prepaidQuantity'],
      bulkQuantity: json['bulkQuantity'],
      totalQuantity: json['totalQuantity'],
      isOlderThanTwoDays: json['isOlderThanTwoDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'prepaidQuantity': prepaidQuantity,
      'bulkQuantity': bulkQuantity,
      'totalQuantity': totalQuantity,
      'isOlderThanTwoDays': isOlderThanTwoDays,
    };
  }

}
