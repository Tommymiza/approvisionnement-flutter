import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static FlutterSecureStorage storage = FlutterSecureStorage();

  static writeData(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  static Future<String> readData(String key) async {
    return await storage.read(key: key) ?? "";
  }

  static deleteData(String key) async {
    await storage.delete(key: key);
  }
}
