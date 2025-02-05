import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/constants/db_constants.dart';

class AutoIncrementService {
  Future<int> getNextCounter(String userCounterFieldName) async {
    try {
      // Create a dynamic reference based on the provided field name
      DocumentReference counterRef = FirebaseFirestore.instance.collection(DbCollections.meta).doc(userCounterFieldName);

      // Start a Firestore transaction to ensure atomicity
      return await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Fetch the current value of the counter
        DocumentSnapshot counterSnapshot = await transaction.get(counterRef);

        // Check if the counter document exists and create it if not
        if (!counterSnapshot.exists) {
          transaction.set(counterRef, {MetaFieldName.value: 1}, SetOptions(merge: true));
          return 1; // Return the first user ID
        }

        // Get the current user counter value
        int currentCounter = counterSnapshot.exists && counterSnapshot.data() != null
            ? (counterSnapshot.data()! as Map<String, dynamic>)[MetaFieldName.value]
            : 0;

        // Increment the counter value
        int nextCounter = currentCounter + 1;

        // Update the counter value in Firestore
        transaction.update(counterRef, {MetaFieldName.value: nextCounter});

        // Return the next user ID
        return nextCounter;
      });
    } catch (e) {
      // Handle any errors that occur during the transaction
      return 0;
    }
  }
}
