import 'package:get_storage/get_storage.dart';

class StorageHelper {
  GetStorage storage = GetStorage();
  void saveData(String key, dynamic value) {
    storage.write(key, value);
    // Add your storage helper methods here
  }

  dynamic readData(String key) {
    return storage.read(key);
  }

  void removeData(String key) {
    storage.remove(key);
  }

  void clearAllData() {
    storage.erase();
  }

  void writeData(String key, dynamic value) {
    storage.write(key, value);
  }
}
