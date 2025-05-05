import 'package:get/get.dart';



class WooAddressRepository extends GetxController {
  static WooAddressRepository get instance => Get.find();

//Fetch customer by mobile
  // Future<AddressModel> fetchAddressCustomerId(String CustomerId) async {
  //   try {
  //     final Map<String, String> queryParams = {
  //       'include': CustomerId, //date, id, include, title, slug, price, popularity and rating. Default is date.
  //       'per_page': '10',
  //       'page': '1',
  //       // 'page': page.toString(),
  //     };
  //
  //     final Uri uri = Uri.https(
  //       APIConstant.wooBaseUrl,
  //       APIConstant.wooProductsApiPath,
  //       queryParams,
  //     );
  //
  //     final response = await http.get(
  //       uri,
  //       // Uri.parse('https://aramarket.in/wp-json/wc/v3/products?category=246&orderby=popularity'),
  //       headers: {
  //         'Authorization': 'Basic ${base64Encode(utf8.encode('${APIConstant.wooConsumerKey}:${APIConstant.wooConsumerSecret}'))}',
  //       },
  //     );
  //
  //     // Check if the request was successful
  //     if (response.statusCode == 200) {
  //       final List<dynamic> addressJson = json.decode(response.body);
  //       // final List<AddressModel> address = AddressModel.fromJson(addressJson) as List<AddressModel>;
  //       return address;
  //     } else {
  //       throw Exception('Failed to fetch products by category');
  //     }
  //   } catch (error) {
  //     if (kDebugMode) {
  //       print('Error creating order: $error');
  //     }
  //   }
  // }
}