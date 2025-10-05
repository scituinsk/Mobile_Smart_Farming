import 'dart:convert';

import 'package:get/get.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';
import 'package:pak_tani/src/features/auth/data/models/user_model.dart';

abstract class AuthLocalDatasource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUserData();
  Future<void> setLoginStatus(bool status);
  Future<bool> getLoginStatus();
}

class AuthLocalDataSourceImpl implements AuthLocalDatasource {
  final StorageService _storageService = Get.find<StorageService>();

  static const String _userCacheKey = 'cached_user';
  static const String _loginStatusKey = 'is_logged_in';

  @override
  Future<void> cacheUser(UserModel user) async {
    final userJson = json.encode(user.toJson());
    await _storageService.write(_userCacheKey, userJson);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = _storageService.read(_userCacheKey);
      if (userJson != null && userJson.isNotEmpty) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      print('error getting cached user: $e');
      return null;
    }
  }

  @override
  Future<void> clearUserData() async {
    await _storageService.delete(_userCacheKey);
  }

  @override
  Future<void> setLoginStatus(bool status) async {
    await _storageService.writeBool(_loginStatusKey, status);
  }

  @override
  Future<bool> getLoginStatus() async {
    return _storageService.readBool(_loginStatusKey)!;
  }
}
