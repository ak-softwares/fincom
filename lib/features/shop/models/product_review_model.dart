import '../../../utils/constants/db_constants.dart';

class ReviewModel {
  int id;
  String? dateCreated;
  int? productId;
  String? productName;
  String? productPermalink;
  String? status;
  String? reviewer;
  String? reviewerEmail;
  String? review;
  String? image;
  int? rating;
  bool? verified;
  String? reviewerAvatarUrl;

  ReviewModel({
    required this.id,
    this.dateCreated,
    this.productId,
    this.productName,
    this.productPermalink,
    this.status,
    this.reviewer,
    this.reviewerEmail,
    this.review,
    this.image,
    this.rating,
    this.verified,
    this.reviewerAvatarUrl,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json[ReviewFieldName.id] ?? 0,
      dateCreated: json[ReviewFieldName.dateCreated] ?? '',
      productId: json[ReviewFieldName.productId] ?? 0,
      productName: json[ReviewFieldName.productName] ?? '',
      productPermalink: json[ReviewFieldName.productPermalink] ?? '',
      status: json[ReviewFieldName.status] ?? '',
      reviewer: json[ReviewFieldName.reviewer] ?? '',
      reviewerEmail: json[ReviewFieldName.reviewerEmail] ?? '',
      review: json[ReviewFieldName.review] ?? '',
      image: json[ReviewFieldName.image] ?? '',
      rating: json[ReviewFieldName.rating] ?? 0,
      verified: json[ReviewFieldName.verified] ?? false,
      reviewerAvatarUrl: json[ReviewFieldName.reviewerAvatarUrls] ?? '',
      // reviewerAvatarUrl48: json[ReviewFieldName.reviewerAvatarUrls] != null && json[ReviewFieldName.reviewerAvatarUrls].containsKey('48') ? json[ReviewFieldName.reviewerAvatarUrls]['48'] : '',
    );
  }
}