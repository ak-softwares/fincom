import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/woocommerce_repositories/product_review/product_review.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../models/product_review_model.dart';

class ProductReviewController extends GetxController {
  static ProductReviewController get instance => Get.find();

  //Variable
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxList<ReviewModel> reviews = <ReviewModel>[].obs;

  RxInt rating = 0.obs;
  //for submit review
  final productReview = TextEditingController();
  GlobalKey<FormState> submitReviewFormKey = GlobalKey<FormState>();

  //for edit review
  RxInt editRating = 0.obs;
  final editProductReview = TextEditingController();
  GlobalKey<FormState> editReviewFormKey = GlobalKey<FormState>();

  final wooReviewRepository = Get.put(WooReviewRepository());
  final userController = Get.put(UserController());

  //Get review by product id
  Future<void> getReviewsByProductId(String productId) async {
    try{
      //fetch products
      final newReviews = await wooReviewRepository.fetchReviewsByProductId(productIds: productId, page: currentPage.toString());
      reviews.addAll(newReviews);
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> refreshReviews(String productId) async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      reviews.clear(); // Clear existing orders
      await getReviewsByProductId(productId);
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  //create review
  Future<void> submitReview(int productId) async {
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('We are adding your review..', Images.docerAnimation);
      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      if(!submitReviewFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      if (rating.value == 0) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'Error', message: 'Star rating is mandatory');
        return;
      }
      //update single field user
      Map<String, dynamic> reviewField = {
        ReviewFieldName.productId: productId,
        ReviewFieldName.rating: rating.value,
        ReviewFieldName.review: productReview.text.trim(),
        ReviewFieldName.reviewer: userController.customer.value.name,
        ReviewFieldName.reviewerEmail: userController.customer.value.email,
        ReviewFieldName.reviewerAvatarUrls: userController.customer.value.avatarUrl ?? '',
      };

      //update single field user
      final ReviewModel review = await wooReviewRepository.submitReview(reviewField);
      // userController.customer(customer);
      productReview.text = '';
      // nickname.text = '';
      // email.text = '';
      //remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.customToast(message: 'Review added successfully!');
      Get.back();
    } catch (error) {
      //remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: error.toString());
    }
  }

  //update review
  Future<void> updateReview(int reviewId) async {
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('We are updating your review..', Images.docerAnimation);
      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      if(!editReviewFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      if (editRating.value == 0) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'Error', message: 'Star rating is mandatory');
        return;
      }
      //update single field user
      Map<String, dynamic> reviewField = {
        ReviewFieldName.rating: editRating.value,
        ReviewFieldName.review: editProductReview.text.trim(),
      };

      //update single field user
      await wooReviewRepository.updateSelectedReview(reviewId, reviewField);

      editProductReview.text = '';
      TFullScreenLoader.stopLoading();
      TLoaders.customToast(message: 'Review updated successfully!');
      Get.back();
    } catch (error) {
      //remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: error.toString());
    }
  }

  //Delete review
  Future<void> deleteReview(int reviewId) async {
    try {
      await wooReviewRepository.deleteSelectedReview(reviewId);
    }  catch (error) {
      TLoaders.errorSnackBar(title: 'Error', message: error.toString());
    }
  }

  //Show dialog box before deleting review
  void deleteReviewDialog(int reviewId) {
    RxBool deleting = false.obs;
    Get.dialog(
      Obx(() {
        return deleting.value
            ? const Center(child: CircularProgressIndicator())
            : AlertDialog(
                title: const Text('Delete Review'),
                content: const Text('Are you sure you want to delete the review?'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      deleting.value = true;
                      // Perform delete operation
                      await deleteReview(reviewId);
                      deleting.value = false;
                      // Show toast and close dialog
                      TLoaders.customToast(message: 'Review Deleted');
                      Get.back();
                    },
                    child: const Text('Delete'),
                  ),
                  TextButton(onPressed: () {Get.back();}, child: const Text('Cancel')),
                ],
              );
      }),
    );
  }

}