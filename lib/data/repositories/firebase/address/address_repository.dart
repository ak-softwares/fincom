import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../features/personalization/models/address_model.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../user/user_repository.dart';


class AddressRepository extends GetxController{
  static AddressRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final userRepository = Get.put(UserRepository());

  Future<List<AddressModel>> fetchUserAddresses() async {
    try{
      final result = await _db.collection(DbCollections.users).doc(await userRepository.getUserDocId()).collection(DbCollections.addresses).get();
      return result.docs.map((documentSnapshot) => AddressModel.fromDocumentSnapshot(documentSnapshot)).toList();

    } catch (e) {
      throw 'Something went wrong while fetching address information. Try again later';
    }
  }

  //Fetch Selected address
  Future<AddressModel> fetchSelectedAddress() async {
    try{
      final result = await _db.collection(DbCollections.users).doc(await userRepository.getUserDocId()).collection(DbCollections.addresses)
          .where(AddressFieldName.selectedAddress, isEqualTo: true).limit(1).get();
      return AddressModel.fromQuerySnapshot(result);
    } catch (e) {
      throw 'Something went wrong while fetching address information. Try again later';
    }
  }

  //Fetch single address
  Future<AddressModel> fetchSingleAddress(String selectedAddressId) async {
    try{
      final result = await _db.collection(DbCollections.users).doc(await userRepository.getUserDocId()).collection(DbCollections.addresses)
          .doc(selectedAddressId).get();
      return AddressModel.fromDocumentSnapshot(result);

    } catch (e) {
      throw 'Something went wrong while fetching address information. Try again later';
    }
  }

  //clear the selected field  for all address
  Future<void> updateSelectedField(String addressId, bool selected) async {
      try{
        await _db.collection(DbCollections.users).doc(await userRepository.getUserDocId()).collection(DbCollections.addresses)
            .doc(addressId).update({AddressFieldName.selectedAddress: selected});
      } catch (e) {
        throw 'Unable to update your address';
      }
  }

  //Store new user address
  Future<String> addAddress(AddressModel address) async {
    try {
      final currentAddress = await _db.collection(DbCollections.users).doc(await userRepository.getUserDocId()).collection(DbCollections.addresses)
          .add(address.toJson());
      return currentAddress.id;
    } catch (e) {
      throw 'Something went wrong while saving address information. Try again later';
    }
  }
}
