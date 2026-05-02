import 'package:get_storage/get_storage.dart';

class StorageHelper {
  GetStorage storage = GetStorage();

  static const _preservedSessionKeys = {
    'hasSeenOnboarding',
    'rememberEmail',
    'theme',
    'dark_mode',
  };

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

  void clearSessionData() {
    final keys = List<String>.from(
      storage.getKeys<Iterable>().map((key) => key.toString()),
    );

    for (final key in keys) {
      if (_preservedSessionKeys.contains(key)) {
        continue;
      }
      storage.remove(key);
    }

    storage.write('hasSeenOnboarding', true);
  }

  void writeData(String key, dynamic value) {
    storage.write(key, value);
  }
}
