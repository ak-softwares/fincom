
import 'package:get_storage/get_storage.dart';

class TLocalStorage{
  late final GetStorage _storage;

  //Singleton instance
  static TLocalStorage? _instance;

  TLocalStorage._internal();

  factory TLocalStorage.instance() {
    _instance ??= TLocalStorage._internal();
    return _instance!;
  }


  //Generic method to save data
  Future<void> saveData<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  //Generic method to read data
  T? readData<T>(String key) {
    return _storage.read(key);
  }

  //Generic Method to remove data
  Future<void> removeData<T>(String key) async {
    await _storage.remove(key);
  }

  //Clear all data in storage
  Future<void> clearAllData() async {
    await _storage.erase();
  }
}