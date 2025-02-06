import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MongoDatabase {
  Db? _db;
  final String _host = dotenv.env['MONGODB_CONNECTION_STRING']!;

  // Constructor to initialize the database connection
  Future<void> connect() async {
    try {
      _db = await Db.create(_host);
      await _db?.open();
      print('MongoDB connection successful');
    } catch (e) {
      print('Error connecting to MongoDB: $e');
    }
  }

  // Insert a document into a collection
  Future<void> insertDocument(String collectionName, Map<String, dynamic> data) async {
    if (_db == null) {
      print('Database is not connected.');
      return;
    }
    try {
      var collection = _db?.collection(collectionName);
      await collection?.insert(data);
      print('Document inserted successfully');
    } catch (e) {
      print('Error inserting document: $e');
    }
  }

  // Fetch documents from a collection
  Future<List<Map<String, dynamic>>> fetchDocuments(String collectionName) async {
    if (_db == null) {
      print('Database is not connected.');
      return [];
    }
    try {
      var collection = _db?.collection(collectionName);
      var documents = await collection?.find().toList();
      print('Documents fetched successfully');
      return documents ?? [];
    } catch (e) {
      print('Error fetching documents: $e');
      return [];
    }
  }

  // Close the MongoDB connection
  Future<void> close() async {
    await _db?.close();
    print('MongoDB connection closed');
  }
}

