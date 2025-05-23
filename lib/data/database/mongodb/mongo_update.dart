import 'package:mongo_dart/mongo_dart.dart';
import 'mongo_base.dart';
import '../../../features/accounts/models/cart_item_model.dart';
import '../../../utils/constants/db_constants.dart';
import '../../../utils/constants/enums.dart';

class MongoUpdate extends MongoDatabase {
  // Singleton implementation
  static final MongoUpdate _instance = MongoUpdate._internal();
  factory MongoUpdate() => _instance;
  MongoUpdate._internal();

  Future<void> _ensureConnected() async {
    await MongoDatabase.ensureConnected();
  }

  Future<void> updateDocumentById({
    required String collectionName,
    required String id,
    required Map<String, dynamic> updatedData,
  }) async {
    await _ensureConnected();
    try {
      final objectId = ObjectId.fromHexString(id);

      // Remove _id from updatedData (if it exists)
      final filteredData = Map<String, dynamic>.from(updatedData)
        ..remove('_id');

      final result = await db!.collection(collectionName).updateOne(
        {'_id': objectId},
        {
          '\$set': updatedData,
        },
        upsert: true,
      );

      if (!result.isSuccess && result.nModified == 0) {
        throw Exception('No document was updated. Possibly invalid ID or no data changes.');
      }
    } catch (e) {
      rethrow;
    }
  }




  Future<void> updateManyDocuments({
    required String collectionName,
    required List<Map<String, dynamic>> updates,
  }) async {
    try {
      await _ensureConnected();
      final collection = db!.collection(collectionName);

      for (var update in updates) {
        final id = update['id'];
        if (id != null) {
          final updateData = Map<String, dynamic>.from(update)..remove('id');
          await collection.updateOne(
            where.eq('id', id),
            {'\$set': updateData},
            upsert: false,
          );
        }
      }

      print('Documents updated successfully');
    } catch (e) {
      throw Exception('Failed to update documents: $e');
    }
  }

  Future<void> updateDocuments({
    required String collectionName,
    required Map<String, dynamic> filter,
    required Map<String, dynamic> updatedData,
  }) async {
    await _ensureConnected();
    try {
      final collection = db!.collection(collectionName);
      await collection.updateMany(
        filter,
        {'\$set': updatedData},
        upsert: true,
      );
    } catch (e) {
      throw Exception('Failed to update documents: $e');
    }
  }

  Future<void> updateDocument({
    required String collectionName,
    required Map<String, dynamic> filter,
    required Map<String, dynamic> updatedData,
    bool upsert = false,
  }) async {
    await _ensureConnected();
    try {
      await db!.collection(collectionName).update(
        filter,
        {'\$set': updatedData},
        upsert: upsert,
      );
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  Future<void> updateManyDocumentsById({
    required String collectionName,
    required List<String> ids,
    required Map<String, dynamic> updatedData,
  }) async {
    await _ensureConnected();

    try {
      if (ids.isEmpty) {
        throw ArgumentError('IDs list cannot be empty');
      }

      final objectIds = ids.map((id) {
        try {
          return ObjectId.fromHexString(id);
        } catch (e) {
          throw FormatException('Invalid ObjectId format for ID: $id');
        }
      }).toList();

      final writeResult = await db!.collection(collectionName).updateMany(
        {OrderFieldName.id: {'\$in': objectIds}},
        {'\$set': updatedData},
        upsert: true,
      );

      if (writeResult.nModified == 0) {
        throw Exception('⚠️ No orders were updated - check if IDs exist');
      }
    } on FormatException catch (e) {
      throw Exception('ID format error: ${e.message}');
    } on MongoDartError catch (e) {
      throw Exception('Database operation failed: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update documents: ${e.toString()}');
    }
  }

  Future<void> updateQuantities({
    required String collectionName,
    required List<CartModel> cartItems,
    bool isAddition = false,
    bool isPurchase = false,
  }) async {
    await _ensureConnected();
    if (cartItems.isEmpty) return;

    try {
      final collection = db!.collection(collectionName);

      final bulkOps = cartItems.map((cartItem) {
        final quantityChange = isAddition ? cartItem.quantity : -cartItem.quantity;

        final updateMap = <String, Map<String, dynamic>> {
          '\$inc': {ProductFieldName.stockQuantity: quantityChange}
        };

        if (isPurchase && cartItem.purchasePrice != null) {
          updateMap['\$set'] = {
            ProductFieldName.purchasePrice: cartItem.purchasePrice!,
          };
        }

        return {
          'updateOne': {
            'filter': {ProductFieldName.productId: cartItem.productId},
            'update': updateMap,
            'upsert': true,
          }
        };
      }).toList();

      await collection.bulkWrite(bulkOps);
    } catch (e) {
      throw Exception('Failed to update product stock: $e');
    }
  }

  Future<void> updateUserBalanceById({
    required String collectionName,
    required int id,
    required double balance,
    required bool isAddition,
  }) async {
    await _ensureConnected();
    try {
      final changeAmount = isAddition ? balance : -balance;

      await db!.collection(collectionName).update(
        where.eq(UserFieldConstants.documentId, id),
        {
          '\$inc': {'balance': changeAmount}
        },
      );
    } catch (e) {
      throw Exception('Failed to update user balance: $e');
    }
  }

  Future<void> updateBalance({
    required String collectionName,
    required String entityId,
    required double amount,
    required bool isAddition,
  }) async {
    await _ensureConnected();
    try {
      final objectId = ObjectId.fromHexString(entityId);

      await db!.collection(collectionName).update(
        where.id(objectId),
        {'\$inc': {'balance': isAddition ? amount : -amount}},
        upsert: true,
      );
    } catch (e) {
      throw Exception('Failed to update balance: $e');
    }
  }

  Future<void> pushMetaDataValue({
    required String collectionName,
    required String metaDataName,
    required String metaFieldName,
    required dynamic value,
  }) async {
    await _ensureConnected();
    try {
      await db!.collection(collectionName).updateOne(
        {MetaDataName.metaDocumentName: metaDataName},
        {'\$set': {metaFieldName: value}},
        upsert: true,
      );
    } catch (e) {
      throw Exception('Failed to update metadata: $e');
    }
  }
}