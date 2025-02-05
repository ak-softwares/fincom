import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController{
  static OnBoardingController get instance => Get.find();

  ///variable
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  //update current index when page scroll
}