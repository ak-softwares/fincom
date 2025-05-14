import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../features/accounts/models/cart_item_model.dart';
import '../../../utils/constants/db_constants.dart';
import '../../../utils/constants/enums.dart';

class MongoDatabase {
  // Singleton implementation
  static final MongoDatabase _instance = MongoDatabase._internal();
  factory MongoDatabase() => _instance;
  MongoDatabase._internal();

  static Db? _db;
  static String? _host;

  // Initialize the database connection
  static Future<void> initialize() async {
    _host = dotenv.env['MONGODB_CONNECTION_STRING'];
    if (_host == null || _host!.isEmpty) {
      throw Exception('MongoDB connection string is not configured');
    }
  }

  // Connect to the database
  static Future<void> connect() async {
    if (_host == null) {
      await initialize();
    }

    if (_db == null || !_db!.isConnected) {
      _db = await Db.create(_host!);
      await _db!.open();
    }
  }

  // Check if database is connected
  static Future<void> _ensureConnected() async {
    try {
      await connect();
    } catch (e) {
      throw Exception('Failed to connect to database: $e');
    }
  }

  // Insert a single document
  Future<void> insertDocument(String collectionName, Map<String, dynamic> data) async {
    await _ensureConnected();
    try {
      await _db!.collection(collectionName).insert(data);
    } catch (e) {
      throw Exception('Failed to insert document: $e');
    }
  }

  Future<String> insertDocumentGetId(String collectionName, Map<String, dynamic> data) async {
    await _ensureConnected();
    try {
      final result = await _db!.collection(collectionName).insertOne(data);

      if (result.isSuccess && result.id != null) {
        return (result.id as ObjectId).toHexString();
      } else {
        throw Exception('Insert failed.');
      }
    } catch (e) {
      throw Exception('Failed to insert document: $e');
    }
  }


  // Insert multiple documents
  Future<void> insertDocuments(String collectionName, List<Map<String, dynamic>> dataList) async {
    await _ensureConnected();
    try {
      await _db!.collection(collectionName).insertMany(dataList);
    } catch (e) {
      throw Exception('Failed to insert documents: $e');
    }
  }

  // Update document by ID
  Future<void> updateDocumentById({required String collectionName, required String id, required Map<String, dynamic> updatedData,
  }) async {
    await _ensureConnected();
    try {
      final objectId = ObjectId.fromHexString(id);
      final writeResult = await _db!.collection(collectionName).updateOne(
        {'_id': objectId},
        {'\$set': updatedData},
      );
    } catch (e) {
      throw Exception('Failed to update document by ID: $e');
    }
  }

  Future<void> updateManyDocuments({
    required String collectionName,
    required List<Map<String, dynamic>> updates, // Each map must contain an 'id' field
  }) async {
    try {
      final collection = _db!.collection(collectionName);

      for (var update in updates) {
        final id = update['id'];
        if (id != null) {
          // Remove 'id' from update map to avoid modifying the identifier
          final updateData = Map<String, dynamic>.from(update)..remove('id');

          await collection.updateOne(
            where.eq('id', id), // Match using custom 'id' field (not MongoDB _id)
            {'\$set': updateData},
            upsert: false, // Only update existing documents
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
      final collection = _db!.collection(collectionName);
      await collection.updateMany(
        filter,
        {'\$set': updatedData},
        upsert: true,
      );
    } catch (e) {
      throw Exception('Failed to update documents: $e');
    }
  }


  // Update document with custom filter
  Future<void> updateDocument({
    required String collectionName,
    required Map<String, dynamic> filter,
    required Map<String, dynamic> updatedData,
    bool upsert = false,
  }) async {
    await _ensureConnected();
    try {
      await _db!.collection(collectionName).update(
        filter,
        {'\$set': updatedData},
        upsert: upsert,
      );
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  // Updates multiple documents by their IDs in a single operation
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

      // Convert all IDs to ObjectId with validation
      final objectIds = ids.map((id) {
        try {
          return ObjectId.fromHexString(id);
        } catch (e) {
          throw FormatException('Invalid ObjectId format for ID: $id');
        }
      }).toList();

      final writeResult = await _db!.collection(collectionName).updateMany(
        {OrderFieldName.id: {'\$in': objectIds}}, // Finds all documents with matching IDs
        {'\$set': updatedData},       // Applies the same updates to all
        upsert: true,               // Optional: create if doesn't exist
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
      final collection = _db!.collection(collectionName);

      final bulkOps = cartItems.map((cartItem) {
        final quantityChange = isAddition ? cartItem.quantity : -cartItem.quantity;

        final updateMap = <String, Map<String, dynamic>> {
          '\$inc': {ProductFieldName.stockQuantity: quantityChange}
        };

        // isPurchase to update purchase price
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

      await _db!.collection(collectionName).update(
        where.eq(UserFieldConstants.userId, id),
        {
          '\$inc': {'balance': changeAmount}
        },
      );
    } catch (e) {
      throw Exception('Failed to update user balance: $e');
    }
  }

  // Search documents with pagination
  Future<List<Map<String, dynamic>>> fetchDocumentsBySearchQuery({
    required String collectionName,
    required String query,
    int page = 1,
    int itemsPerPage = 10,
    Map<String, dynamic>? filter, // ✅ Optional filter parameter
  }) async {
    await _ensureConnected();

    try {
      final pipeline = [
        {
          "\$search": {
            "index": "default",
            "text": {
              "query": query,
              "path": {"wildcard": "*"}
            }
          }
        },
        if (filter != null && filter.isNotEmpty)
          {"\$match": filter}, // ✅ Optional filter stage
        {"\$skip": (page - 1) * itemsPerPage},
        {"\$limit": itemsPerPage}
      ];

      return await _db!
          .collection(collectionName)
          .aggregateToStream(pipeline)
          .toList();
    } catch (e) {
      throw Exception('Failed to search documents: $e');
    }
  }

  // Fetch document by ID
  Future<Map<String, dynamic>> fetchDocumentById({
    required String collectionName,
    required String id,
  }) async {
    await _ensureConnected();
    try {
      final objectId = ObjectId.fromHexString(id);
      var document = await _db!.collection(collectionName).findOne({'_id': objectId});
      if (document == null) {
        throw Exception('Document not found with ID: $id');
      }
      return document;
    } catch (e) {
      throw Exception('Failed to fetch document by ID: $e');
    }
  }

  // Fetch documents with pagination
  Future<List<Map<String, dynamic>>> fetchDocuments({
    required String collectionName,
    Map<String, dynamic>? filter,
    int page = 1,
    int itemsPerPage = 10
  }) async {
    await _ensureConnected();
    var collection = _db!.collection(collectionName);
    int skip = (page - 1) * itemsPerPage;

    try {
      var query = where
        ..sortBy('_id', descending: true)
        ..skip(skip)
        ..limit(itemsPerPage);

      // If filter is provided, add it
      if (filter != null) {
        filter.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      var documents = await collection.find(query).toList();
      return documents;
    } catch (e) {
      throw Exception('Error fetching documents: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchDocumentsDate({
    required String collectionName,
    Map<String, dynamic>? filter,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await _ensureConnected();
    var collection = _db!.collection(collectionName);

    try {
      var query = where..sortBy('_id', descending: true);

      // Apply filter if provided
      if (filter != null) {
        filter.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      // Apply date range filter (assumes 'createdAt' is the date field)
      query = query.gte(OrderFieldName.dateCreated, startDate);
      query = query.lte(OrderFieldName.dateCreated, endDate);

      var documents = await collection.find(query).toList();
      return documents;
    } catch (e) {
      throw Exception('Error fetching documents: $e');
    }
  }

  // Fetch products with custom stock sorting (positive first, then negative, then zero)
  Future<List<Map<String, dynamic>>> fetchProducts({
    required String collectionName,
    int page = 1,
    int itemsPerPage = 10,
  }) async {
    await _ensureConnected();
    try {
      final pipeline = [
        {
          "\$addFields": {
            "totalStock": "\$${ProductFieldName.stockQuantity}",
            // Add a field to determine sorting priority (1=positive, -1=negative, 0=zero)
            "stockPriority": {
              "\$switch": {
                "branches": [
                  {
                    "case": {"\$gt": ["\$${ProductFieldName.stockQuantity}", 0]},
                    "then": 2
                  },
                  {
                    "case": {"\$lt": ["\$${ProductFieldName.stockQuantity}", 0]},
                    "then": 1
                  },
                ],
                "default": 0
              }
            },
            // Add absolute value for secondary sorting
            "absStock": {"\$abs": "\$${ProductFieldName.stockQuantity}"}
          }
        },
        {
          "\$sort": {
            "stockPriority": -1,  // 2 (positive), then 1 (negative), then 0 (zero)
            "absStock": -1,       // Highest absolute values first
            ProductFieldName.id: -1 // Finally by product ID
          }
        },
        {"\$skip": (page - 1) * itemsPerPage},
        {"\$limit": itemsPerPage},
        // Remove temporary fields if needed
        {
          "\$project": {
            "stockPriority": 0,
            "absStock": 0
          }
        }
      ];

      return await _db!
          .collection(collectionName)
          .aggregateToStream(pipeline)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<double> fetchTotalStockValue({required String collectionName}) async {
    await _ensureConnected();
    try {
      final pipeline = [
        {
          // Match only products where stock and purchase price are both > 0
          "\$match": {
            ProductFieldName.stockQuantity: {"\$ne": 0},
            ProductFieldName.purchasePrice: {"\$ne": 0},
          }
        },
        {
          // Add a field for stockValue = stockQuantity * purchasePrice
          "\$addFields": {
            "stockValue": {
              "\$multiply": [
                "\$${ProductFieldName.stockQuantity}",
                "\$${ProductFieldName.purchasePrice}"
              ]
            }
          }
        },
        {
          // Group and sum all stockValue
          "\$group": {
            "_id": null,
            "totalStockValue": {"\$sum": "\$stockValue"}
          }
        }
      ];

      final result = await _db!
          .collection(collectionName)
          .aggregateToStream(pipeline)
          .toList();

      if (result.isNotEmpty && result[0]['totalStockValue'] != null) {
        return (result[0]['totalStockValue'] as num).toDouble();
      } else {
        return 0.0;
      }
    } catch (e) {
      throw Exception('Failed to calculate stock value: $e');
    }
  }

  Future<double> fetchTotalAccountBalance({required String collectionName}) async {
    await _ensureConnected();
    try {
      final pipeline = [
        {
          // Only consider documents with a non-null balance
          "\$match": {
            AccountFieldName.balance: {"\$ne": null}
          }
        },
        {
          // Sum all balance fields
          "\$group": {
            "_id": null,
            "totalBalance": {"\$sum": "\$balance"}
          }
        }
      ];

      final result = await _db!
          .collection(collectionName)
          .aggregateToStream(pipeline)
          .toList();

      if (result.isNotEmpty && result[0]['totalBalance'] != null) {
        return (result[0]['totalBalance'] as num).toDouble();
      } else {
        return 0.0;
      }
    } catch (e) {
      throw Exception('Failed to calculate total balance: $e');
    }
  }

  Future<double> calculateAccountPayable({
    required String collectionName,
    Map<String, dynamic>? filter,
  }) async {
    await _ensureConnected();
    try {
      final pipeline = [
        {
          r'$match': filter ?? {},
        },
        {
          r'$group': {
            '_id': null,
            'totalBalance': {
              r'$sum': '\$${UserFieldConstants.balance}', // <-- dynamic field name here
            }
          }
        }
      ];

      final result = await _db!
          .collection(collectionName)
          .aggregateToStream(pipeline)
          .toList();

      if (result.isNotEmpty && result[0]['totalBalance'] != null) {
        return (result[0]['totalBalance'] as num).toDouble();
      } else {
        return 0.0;
      }
    } catch (e) {
      throw Exception('Failed to calculate total account balance: $e');
    }
  }



  Future<List<Map<String, dynamic>>> fetchCogsDetailsByProductIds({
    required String collectionName,
    required List<int> productIds,
  }) async {
    await _ensureConnected();

    try {
      final pipeline = [
        {
          "\$match": {
            ProductFieldName.productId: {"\$in": productIds}
          }
        },
        {
          "\$project": {
            ProductFieldName.productId: 1,
            ProductFieldName.purchasePrice: 1,
            "_id": 0
          }
        }
      ];

      final result = await _db!
          .collection(collectionName)
          .aggregateToStream(pipeline)
          .toList();

      return result.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to fetch product COGS details: $e');
    }
  }


  Future<double> fetchInTransitStockValue({
    required String collectionName,
    required OrderType orderType,
    required OrderStatus orderStatus,
  }) async {
    await _ensureConnected();
    try {
      final pipeline = [
        {
          // Match orders with given status and orderType
          "\$match": {
            OrderFieldName.status: orderStatus.name,
            OrderFieldName.orderType: orderType.name,
          }
        },
        {
          // Unwind the line_items array
          "\$unwind": "\$${OrderFieldName.lineItems}"
        },
        {
          // Filter only items with valid quantity and purchase_price
          "\$match": {
            "${OrderFieldName.lineItems}.${ProductFieldName.purchasePrice}": {"\$gt": 0},
            "${OrderFieldName.lineItems}.quantity": {"\$gt": 0}
          }
        },
        {
          // Calculate stock value
          "\$addFields": {
            "stockValue": {
              "\$multiply": [
                "\$${OrderFieldName.lineItems}.quantity",
                "\$${OrderFieldName.lineItems}.${ProductFieldName.purchasePrice}"
              ]
            }
          }
        },
        {
          // Sum up the values
          "\$group": {
            "_id": null,
            "totalInTransitStockValue": {"\$sum": "\$stockValue"}
          }
        }
      ];

      final result = await _db!
          .collection(collectionName)
          .aggregateToStream(pipeline)
          .toList();

      if (result.isNotEmpty && result[0]['totalInTransitStockValue'] != null) {
        return (result[0]['totalInTransitStockValue'] as num).toDouble();
      } else {
        return 0.0;
      }
    } catch (e) {
      throw Exception('Failed to fetch in-transit stock value: $e');
    }
  }

  // Fetch documents by IDs
  Future<List<Map<String, dynamic>>> fetchDocumentsByFieldName({
    required String collectionName,
    required String fieldName,
    required List<int> documentIds,
  }) async {
    await _ensureConnected();
    try {
      return await _db!
          .collection(collectionName)
          .find(where.oneFrom(fieldName, documentIds))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch documents by IDs: $e');
    }
  }

  // Fetch transactions by entity
  Future<List<Map<String, dynamic>>> fetchTransactionByEntity({
    required String collectionName,
    required EntityType entityType,
    required int entityId,
    int page = 1,
    int itemsPerPage = 10,
  }) async {
    await _ensureConnected();
    try {
      final skip = (page - 1) * itemsPerPage;
      final query = where
          .eq('from_entity_type', entityType.name)
          .eq('from_entity_id', entityId)
          .or(where
          .eq('to_entity_type', entityType.name)
          .eq('to_entity_id', entityId))
          .sortBy('_id', descending: true)
          .skip(skip)
          .limit(itemsPerPage);

      return await _db!.collection(collectionName).find(query).toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  // Delete document by ID
  Future<void> deleteDocumentById({
    required String collectionName,
    required String id,
  }) async {
    await _ensureConnected();
    try {
      if (id.isEmpty || id.length != 24) {
        throw Exception("Invalid ID format: Expected a 24-character hex string");
      }

      final objectId = ObjectId.fromHexString(id);
      final result = await _db!
          .collection(collectionName)
          .deleteOne({'_id': objectId});

      if (result.nRemoved == 0) {
        throw Exception("No document found with ID: $id");
      }
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  // Get next ID in sequence
  Future<int> getNextId({
    required String collectionName,
    required String fieldName,
    Map<String, dynamic>? filter,
  }) async {
    await _ensureConnected();
    var collection = _db!.collection(collectionName);
    try {
      var query = where.sortBy(fieldName, descending: true).limit(1);

      // Apply filter if provided
      if (filter != null) {
        filter.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      var lastDocument = await collection.find(query).toList();

      if (lastDocument.isEmpty) {
        return 1; // Start from 1 if no documents match
      } else {
        return lastDocument[0][fieldName] + 1;
      }
    } catch (e) {
      throw Exception('Error fetching the next ID: $e');
    }
  }

  // Update entity balance
  Future<void> updateBalance({
    required String collectionName,
    required String entityId,
    required double amount,
    required bool isAddition,
  }) async {
    await _ensureConnected();
    try {
      final objectId = ObjectId.fromHexString(entityId);

      await _db!.collection(collectionName).update(
        where.id(objectId),
        {'\$inc': {'balance': isAddition ? amount : -amount}},
      );
    } catch (e) {
      throw Exception('Failed to update balance: $e');
    }
  }

  // Fetch all IDs in collection
  Future<Set<int>> fetchCollectionIds(String collectionName) async {
    await _ensureConnected();
    try {
      final collection = _db!.collection(collectionName);
      final allIds = <int>{};
      int page = 1;
      const pageSize = 1000;

      while (true) {
        final batch = await collection
            .find(where.fields([ProductFieldName.productId]).skip((page - 1) * pageSize).limit(pageSize))
            .toList();

        if (batch.isEmpty) break;

        allIds.addAll(batch.map((p) => p[ProductFieldName.productId] as int));
        page++;
      }

      return allIds;
    } catch (e) {
      throw Exception('Failed to fetch collection IDs: $e');
    }
  }

  // Get document count
  Future<int> fetchCollectionCount(String collectionName) async {
    await _ensureConnected();
    try {
      return await _db!.collection(collectionName).count() ?? 0;
    } catch (e) {
      throw Exception('Failed to get collection count: $e');
    }
  }

  // Delete documents matching filter
  Future<void> deleteDocuments({
    required String collectionName,
    required Map<String, dynamic> filter,
  }) async {
    await _ensureConnected();
    try {
      await _db!.collection(collectionName).deleteMany(filter);
    } catch (e) {
      throw Exception('Failed to delete documents: $e');
    }
  }

  // Fetch metadata documents
  Future<Map<String, dynamic>?> fetchMetaDocuments({
    required String collectionName,
    required String metaDataName,
  }) async {
    await _ensureConnected();
    try {
      return await _db!
          .collection(collectionName)
          .findOne({MetaDataName.metaDocumentName: metaDataName});
    } catch (e) {
      throw Exception('Failed to fetch metadata: $e');
    }
  }

  // Update metadata
  Future<void> pushMetaDataValue({
    required String collectionName,
    required String metaDataName,
    required String metaFieldName,
    required dynamic value,
  }) async {
    await _ensureConnected();
    try {
      await _db!.collection(collectionName).updateOne(
        {MetaDataName.metaDocumentName: metaDataName},
        {'\$set': {metaFieldName: value}},
        upsert: true,
      );
    } catch (e) {
      throw Exception('Failed to update metadata: $e');
    }
  }

  // Find one document matching query
  Future<Map<String, dynamic>?> findOne({
    required String collectionName,
    required Map<String, dynamic> query,
  }) async {
    await _ensureConnected();
    try {
      return await _db!.collection(collectionName).findOne(query);
    } catch (e) {
      throw Exception('Failed to find document: $e');
    }
  }

  // Find multiple documents matching query
  Future<List<Map<String, dynamic>>> findMany({
    required String collectionName,
    required Map<String, dynamic> query,
  }) async {
    await _ensureConnected();
    try {
      return await _db!.collection(collectionName).find(query).toList();
    } catch (e) {
      throw Exception('Failed to find documents: $e');
    }
  }

  // Close database connection
  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}