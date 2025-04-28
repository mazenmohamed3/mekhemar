// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// class SecureStorageHelper {
//   static const _storage = FlutterSecureStorage();
//
//   static Future<void> saveLoginInfo(String email, String password) async {
//     await _storage.write(key: 'email', value: email);
//     await _storage.write(key: 'password', value: password);
//   }
//
//   static Future<Map<String, String?>> loadLoginInfo() async {
//     final email = await _storage.read(key: 'email');
//     final password = await _storage.read(key: 'password');
//     return {'email': email, 'password': password};
//   }
//
//   static Future<void> clearLoginInfo() async {
//     await _storage.delete(key: 'email');
//     await _storage.delete(key: 'password');
//   }
// }