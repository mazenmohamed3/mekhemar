import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  // Create a static instance of FlutterSecureStorage
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Save value to secure storage (static method)
  static Future<void> writeValueToKey({required String key, required String value}) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      print('Error saving value to secure storage: $e');
    }
  }

  // Retrieve value from secure storage (static method)
  static Future<String?> readValueFromKey({required String key}) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      print('Error reading value from secure storage: $e');
      return null;
    }
  }

  // Delete specific value from secure storage (static method)
  static Future<void> deleteValueFromKey({required String key}) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print('Error deleting value from secure storage: $e');
    }
  }

  // Clear all stored values (static method)
  static Future<void> clearAllValues() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      print('Error clearing secure storage: $e');
    }
  }
}
