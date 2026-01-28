/// Service for local storage.
/// Handle write, read, and delete data.
/// Using shared preferences for regular data and secure storage for token.

library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pak_tani/src/features/modul/domain/entities/feature_data.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul_feature.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for Storage service.
class StorageService extends GetxService {
  ///instance of shared preferences
  late SharedPreferences _prefs;

  ///Instance of flutter secure storage
  late FlutterSecureStorage _secureStorage;

  // init shared preferences, flutter secure storage, and hive
  @override
  void onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
    _secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(resetOnError: true),
    );

    await Hive.initFlutter();
    Hive.registerAdapter(ModulAdapter());
    Hive.registerAdapter(ModulFeatureAdapter());
    Hive.registerAdapter(FeatureDataAdapter());
  }

  /// Write string with key to shared preferences
  Future<void> write(String key, String value) async {
    await _prefs.setString(key, value);
  }

  /// Write boolean with key to shared preferences
  Future<void> writeBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  /// Write Integer with key to shared preferences
  Future<void> writeInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  /// Read String using key in shared preference.
  String? read(String key) => _prefs.getString(key);

  /// Read boolean using key in shared preferences.
  bool? readBool(String key) => _prefs.getBool(key);

  /// Read Integer using key in shared preferences.
  int? readInt(String key) => _prefs.getInt(key);

  /// Delete any data in shared prefences based on key.
  Future<void> delete(String key) async {
    await _prefs.remove(key);
  }

  /// Write String with key to secure storage
  Future<void> writeSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Read String using key in secure storage.
  Future<String?> readSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  /// Delete any data in secure storage based on key.
  Future<void> deleteSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// Delete all datas in sharedPreferences and secure storage
  Future<void> clearAll() async {
    await _prefs.clear();
    await _secureStorage.deleteAll();
  }

  /// Delete all datas in secure storage.
  Future<void> clearOnlySecure() async {
    await _secureStorage.deleteAll();
  }

  /// Delete all data in shared preferences.
  Future<void> clearOnlyPrefs() async {
    await _prefs.clear();
  }
}
