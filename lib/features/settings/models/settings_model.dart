//for woocommerce
import '../../../utils/constants/db_constants.dart';

class AppSettingsModel {
  String? siteName;
  String? siteUrl;
  String? currency;
  List<String>? blockedPincodes;

  AppSettingsModel({
    this.siteName,
    this.siteUrl,
    this.currency,
    this.blockedPincodes,
  });

  static AppSettingsModel empty() => AppSettingsModel();

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      siteName: json[AppSettingsFieldName.siteName] ?? '',
      siteUrl: json[AppSettingsFieldName.siteUrl] ?? '',
      currency: json[AppSettingsFieldName.currency] ?? '',
      blockedPincodes: List<String>.from(json[AppSettingsFieldName.blockedPincodes] ?? []),
    );
  }
}