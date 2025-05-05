import 'package:get/get.dart';

import '../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../data/repositories/mongodb/user/user_repositories.dart';
import '../../../data/repositories/woocommerce/customers/woo_customer_repository.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final mongoUserRepository = Get.put(MongoUserRepository());
  final wooCustomersRepository = Get.put(WooCustomersRepository());

  // Get All Customers Counts
  Future<int> getTotalCustomerCount() async {
    try {
      // Fetch the total customer count
      final int totalCustomers = await wooCustomersRepository.fetchCustomerCount();
      return totalCustomers;
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error in Customer Count Fetching', message: e.toString());
      return 0; // Return 0 in case of an error
    }
  }

  // Get All Customers
  Future<List<UserModel>> getAllCustomers(String page) async {
    try{
      //fetch products
      final customers = await wooCustomersRepository.fetchAllCustomers(page: page);
      return customers;
    } catch (e){
      AppMassages.errorSnackBar(title: 'Error in Customers Fetching', message: e.toString());
      return [];
    }
  }

  Future<void> updateUserBalance({required int userID, required double balance, double? previousBalance, bool? isUpdate, required bool isAddition}) async {
    try {
      if((isUpdate ?? false) && (previousBalance != null)){
        double balanceDifference = (balance - previousBalance);
        await mongoUserRepository.updateUserBalance(userID: userID, balance: balanceDifference, isAddition: isAddition);
      } else {
        await mongoUserRepository.updateUserBalance(userID: userID, balance: balance, isAddition: isAddition);
      }
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error in User Balance Updating', message: e.toString());
    }
  }
}