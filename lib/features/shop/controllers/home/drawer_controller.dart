import 'package:get/get.dart';

class HomeDrawerController extends GetxController {
  static HomeDrawerController get instance => Get.find();

  RxBool isLoading = false.obs;

}