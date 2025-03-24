import 'package:fincom/features/shop/models/transaction_model.dart';
import 'package:fincom/features/shop/models/vendor_model.dart';
import 'package:fincom/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box/dialog_massage.dart';
import '../../../../common/widgets/loaders/loader.dart';
import '../../../../data/repositories/mongodb/transaction/transaction_repo.dart';
import '../../../../data/repositories/mongodb/vendors/vendors_repositories.dart';


class VendorController extends GetxController{
  static VendorController get instance => Get.find();

  // Variable
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;

  RxBool isGettingCount = false.obs;
  RxInt vendorCounts = 0.obs;

  RxList<VendorModel> vendors = <VendorModel>[].obs;
  final mongoVendorsRepo = Get.put(MongoVendorsRepo());
  final mongoTransactionRepo = Get.put(MongoTransactionRepo());


  // Get total customer count
  Future<void> getTotalVendorCount() async {
    try {
      isGettingCount(true);
      int vendorCountsNew = await mongoVendorsRepo.fetchVendorCount();
      vendorCounts(vendorCountsNew);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in Vendor Count Fetching', message: e.toString());
    } finally {
      isGettingCount(false);
    }
  }

  // Get All products
  Future<void> getAllVendors() async {
    try {
      final fetchedVendors = await mongoVendorsRepo.fetchAllVendors(page: currentPage.value);
      vendors.addAll(fetchedVendors);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in vendors getting', message: e.toString());
    }
  }

  Future<void> refreshVendors() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      vendors.clear(); // Clear existing orders
      await getAllVendors();
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Errors', message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Get vendor by id
  Future<VendorModel> getVendorByID({required String id}) async {
    try {
      final fetchedVendor = await mongoVendorsRepo.fetchVendorById(id: id);
      return fetchedVendor;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in vendor getting', message: e.toString());
      return VendorModel();
    }
  }

  Future<void> deletePurchase ({required String id, required BuildContext context}) async {
    try {
      DialogHelper.showDialog(
          context: context,
          title: 'Delete Vendor',
          message: 'Are you sure to delete this Vendor',
          function: () async { await mongoVendorsRepo.deleteVendor(id: id); },
          toastMessage: 'Deleted successfully!'
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }


}