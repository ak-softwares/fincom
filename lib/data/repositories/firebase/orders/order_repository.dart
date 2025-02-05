import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../features/shop/models/order_model.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../authentication/authentication_repository.dart';


class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  //Variables
  final _db = FirebaseFirestore.instance;
  /*---------------Functions------------------*/

  //Get all order related to current user
  Future<List<OrderModel>> fetchUserOrders() async {
    try{
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if(userId!.isEmpty) throw 'Unable to find user information';

      // final result = await _db.collection('Orders').get();
      final result = await _db.collection(DbCollections.orders).where(OrderFieldName.customerId, isEqualTo: userId).get();
      return result.docs.map((document) => OrderModel.fromSnapshot(document)).toList();
    }catch(e) {
      throw e.toString();
      // throw 'Something went wrong while fetching orders. Try again later';
    }
  }

  //Store new user order
  Future<void> saveOrder(OrderModel order) async {
    try{
      await _db.collection(DbCollections.orders).doc(order.id.toString()).set(order.toJson());
    }catch(e){
      throw 'Something went wrong while saving Order';
    }
  }
}