import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String> writeSecureData(String key, String value) async {
    try {
      await storage.write(key: key, value: value);
      return "true";
    } catch (e) {
      // throw Exception(e);
      return "false";
    }
  }

  Future<String> readSecureData(String key) async {
    try{
    String value = await storage.read(key: key) ?? 'No data found';
    print('Data read from secure storage');
    return value;
    }catch(e){
      // throw Exception(e);
      return "false";
    }
  }

  Future<String> deleteSecureData(String key) async {
    try{
    await storage.delete(key: key);
    return "true";
    }catch(e){
      // throw Exception(e);
      return "false";
    }
  }
}
