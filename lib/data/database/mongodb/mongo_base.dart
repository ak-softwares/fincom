import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MongoDatabase {
  // static final MongoBase _instance = MongoBase._internal();
  // factory MongoBase() => _instance;
  // MongoBase._internal();

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
  static Future<void> ensureConnected() async {
    try {
      await connect();
    } catch (e) {
      throw Exception('Failed to connect to database: $e');
    }
  }

  // Close database connection
  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  // Getter for the database instance
  Db? get db => _db;
}