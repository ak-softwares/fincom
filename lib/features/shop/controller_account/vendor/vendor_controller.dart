import 'package:fincom/features/shop/models/vendor_model.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/loaders/loader.dart';
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

}