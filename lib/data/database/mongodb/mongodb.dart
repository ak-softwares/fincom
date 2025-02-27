import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MongoDatabase {
  static Db? _db;
  static final String _host = dotenv.env['MONGODB_CONNECTION_STRING']!;

  static connect() async {
    _db = await Db.create(_host);
    await _db?.open();
  }

  Future<void> _ensureConnected() async {
    if (_db == null || !_db!.isConnected) {
      await connect();
    }
  }

  // Insert a document into a collection
  Future<void> insertDocument(String collectionName, Map<String, dynamic> data) async {
    try {
      var collection = _db?.collection(collectionName);
      await collection?.insert(data);
      print('Document inserted successfully');
    } catch (e) {
      print('Error inserting document: $e');
    }
  }

  // Insert multiple documents into a collection
  Future<void> insertDocuments(String collectionName, List<Map<String, dynamic>> dataList) async {
    try {
      var collection = _db?.collection(collectionName);
      await collection?.insertMany(dataList); // Insert multiple documents
    } catch (e) {
      throw Exception('Error inserting documents: $e');
    }
  }

  // Fetch documents with search, pagination, and field selection
  Future<List<Map<String, dynamic>>> fetchDocumentsBySearchQuery({required String collectionName, required String query, int page = 1, int itemsPerPage = 10,}) async {

    var collection = _db!.collection(collectionName);
    // Calculate the number of documents to skip
    int skip = (page - 1) * itemsPerPage;

    // MongoDB Aggregation Pipeline for Autocomplete Search
    final List<Map<String, Object>> pipeline = [
      {
        "\$search": {
          "index": collectionName != "orders" ? "default" : "orders",
          "text": {
            "query": query,
            "path": {
              "wildcard": "*"
            }
          }
        }
      },
      {"\$skip": skip},
      {"\$limit": itemsPerPage}
    ];

    try {
      final List<Map<String, dynamic>> results = await collection.aggregateToStream(pipeline).toList();
      return results;
    } catch (e) {
      throw Exception('Error searching documents: $e');
    }
  }

  // Fetch documents from a collection
  Future<List<Map<String, dynamic>>> fetchDocuments({required String collectionName, int page = 1, int itemsPerPage = 10}) async {
    var collection = _db!.collection(collectionName);
    // Calculate the number of documents to skip
    int skip = (page - 1) * itemsPerPage;

    try {
      var documents = await collection
          .find(where.skip(skip).limit(itemsPerPage)) // Apply pagination correctly
          .toList(); // Convert to List<Map<String, dynamic>>

      return documents;
    } catch (e) {
      throw Exception('Error fetching documents: $e');
    }
  }

  // Fetch documents by IDs from a collection
  Future<List<Map<String, dynamic>>> fetchDocumentsByIds(String collectionName, List<int> documentIds) async {
    try {
      var collection = _db!.collection(collectionName);

      // Query to find documents matching the given IDs
      var documents = await collection
          .find(where.oneFrom('id', documentIds)) // Query documents with IDs
          .toList(); // Convert to List<Map<String, dynamic>>

      return documents;
    } catch (e) {
      throw Exception('Error fetching documents by IDs: $e');
    }
  }

  // Fetch Collection All IDs
  Future<Set<int>> fetchCollectionIds(String collectionName) async {
    try {
      var collection = _db!.collection(collectionName);
      Set<int> allIds = {};
      int page = 1;
      int pageSize = 1000;

      while (true) {
        int skipCount = (page - 1) * pageSize;

        // Fetch only the 'id' field with pagination
        List<Map<String, dynamic>> batch = await collection
            .find(where.fields(['id']).skip(skipCount).limit(pageSize))
            .toList();

        if (batch.isEmpty) break; // Stop when no more data is available

        allIds.addAll(batch.map((p) => p['id'] as int)); // Collect IDs
        page++; // Move to next batch
      }

      return allIds;
    } catch (e) {
      throw Exception('Failed to fetch Collection IDs: $e');
    }
  }

  // Get the count of documents in a collection
  Future<int> fetchCollectionCount(String collectionName) async {
    try {
      var collection = _db?.collection(collectionName);
      int? count = await collection?.count(); // Get document count
      return count ?? 0;
    } catch (e) {
      throw Exception('Error getting collection count: $e');
    }
  }

  // Delete all documents from a collection
  Future<void> deleteDocuments({required String collectionName, required Map<String, dynamic> filter,}) async {
    var collection = _db!.collection(collectionName);

    try {
      // Delete all documents by passing an empty filter
      await collection.deleteMany(filter);
    } catch (e) {
      throw Exception('Error deleting documents: $e');
    }
  }

  // Fetch documents from a collection
  Future<String> fetchMetaDocuments({required String collectionName, required String metaDataName}) async {
    if (_db == null) {
      throw Exception('Database connection is not initialized.');
    }
    var collection = _db!.collection(collectionName);

    try {
      var document = await collection.findOne({'id': 123}); // Fetch the document with ID 123

      if (document != null && document.containsKey(metaDataName) && document[metaDataName] is String) {
        return document[metaDataName] as String; // Return the stored string
      }

      return ''; // Return an empty string if metadata doesn't exist

    } catch (e) {
      throw Exception('Error fetching documents: $e');
    }
  }

  // Push a new value to the metadata list
  Future<void> pushMetaDataValue({required String collectionName, required String metaDataName, required List<dynamic> value,}) async {
    if (_db == null) {
      throw Exception('Database connection is not initialized.');
    }

    var collection = _db!.collection(collectionName);

    try {
      await collection.updateOne(
        {'id': 123}, // Find the document by ID
        {'\$set': {metaDataName: value.join(',')}}, // Store as a comma-separated string
        upsert: true, // Create the document if it doesn't exist
      );
    } catch (e) {
      throw Exception('Error pushing to metadata: $e');
    }
  }

  // Delete the entire metadata field from the document
  Future<void> deleteMetaDataField({required String collectionName, required String metaDataName}) async {
    if (_db == null) {
      throw Exception('Database connection is not initialized.');
    }

    var collection = _db!.collection(collectionName);

    try {
      await collection.updateOne(
        {'id': 123},
        {
          '\$unset': {metaDataName: ""} // Remove the field from the document
        },
      );
    } catch (e) {
      throw Exception('Error deleting metadata field: $e');
    }
  }

  Future<Map<String, dynamic>?> findOne(String collectionName, Map<String, dynamic> query) async {
    var collection = _db!.collection(collectionName);

    try {
      var document = await collection.findOne(query); // Find a single document

      return document; // Returns null if no match is found
    } catch (e) {
      throw Exception('Error finding document: $e');
    }
  }


  // Close the connection
  void close() {
    _db?.close();
    print('MongoDB connection closed.');
  }

}

