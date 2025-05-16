import 'package:mongo_dart/mongo_dart.dart';
import 'mongo_base.dart';

class MongoDelete extends MongoDatabase {
  // Singleton implementation
  static final MongoDelete _instance = MongoDelete._internal();
  factory MongoDelete() => _instance;
  MongoDelete._internal();

  Future<void> _ensureConnected() async {
    await MongoDatabase.ensureConnected();
  }

  // Delete document by ID
  Future<void> deleteDocumentById({required String collectionName, required String id}) async {
    await _ensureConnected();
    try {
      if (id.isEmpty || id.length != 24) {
        throw Exception("Invalid ID format: Expected a 24-character hex string");
      }

      final objectId = ObjectId.fromHexString(id);
      final result = await db!
          .collection(collectionName)
          .deleteOne({'_id': objectId});

      if (result.nRemoved == 0) {
        throw Exception("No document found with ID: $id");
      }
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  // Delete documents matching filter
  Future<void> deleteDocuments({required String collectionName, required Map<String, dynamic> filter}) async {
    await _ensureConnected();
    try {
      await db!.collection(collectionName).deleteMany(filter);
    } catch (e) {
      throw Exception('Failed to delete documents: $e');
    }
  }
}