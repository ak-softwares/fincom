import '../../../utils/constants/db_constants.dart';

class PaymentModel {
  final String id;
  final String title;
  final String description;
  final String? image;
  final String? key;
  final String? secret;

  PaymentModel({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    this.key,
    this.secret
  });

  static PaymentModel empty() => PaymentModel(id: '', title: '', description: '');

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json[PaymentFieldName.id],
      title: json[PaymentFieldName.title],
      description: json[PaymentFieldName.description],
      image: json[PaymentFieldName.image],
      key: json[PaymentFieldName.key],
      secret: json[PaymentFieldName.secret],
    );
  }

  static List<PaymentModel> parsePaymentModels(List<Map<String, String>> paymentJson) {
    List<PaymentModel> paymentModels = [];
    for (var paymentData in paymentJson) {
      paymentModels.add(PaymentModel(
        id: paymentData[PaymentFieldName.id]!,
        title: paymentData[PaymentFieldName.title]!,
        description: paymentData[PaymentFieldName.description]!,
        image: paymentData[PaymentFieldName.image],
        key: paymentData[PaymentFieldName.key],
        secret: paymentData[PaymentFieldName.secret],
      ));
    }
    return paymentModels;
  }
}