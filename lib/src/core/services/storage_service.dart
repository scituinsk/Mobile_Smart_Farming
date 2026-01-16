import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;
  late FlutterSecureStorage _secureStorage;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
    _secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
  }

  Future<void> write(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<void> writeBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<void> writeInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  String? read(String key) => _prefs.getString(key);
  bool? readBool(String key) => _prefs.getBool(key);
  int? readInt(String key) => _prefs.getInt(key);

  Future<void> delete(String key) async {
    await _prefs.remove(key);
  }

  //secure storage for tokens
  Future<void> writeSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> readSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
    await _secureStorage.deleteAll();
  }

  Future<void> clearOnlySecure() async {
    await _secureStorage.deleteAll();
  }

  Future<void> clearOnlyPrefs() async {
    await _prefs.clear();
  }
}
