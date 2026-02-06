import 'dart:io';

import 'package:pak_tani/src/features/profile/domain/datasources/profile_remote_datasource.dart';
import 'package:pak_tani/src/features/profile/domain/entities/user.dart';
import 'package:pak_tani/src/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileRemoteDatasource _remoteDatasource;
  ProfileRepositoryImpl(this._remoteDatasource);

  @override
  Future<User?> getUserProfile() async {
    try {
      final userProfile = await _remoteDatasource.getUserProfile();
      if (userProfile == null) return null;
      return userProfile.toEntity();
    } catch (e) {
      print("error get user profile (repo): $e");
      rethrow;
    }
  }

  @override
  Future<User> editUserProfile({
    String? firstname,
    String? lastName,
    String? username,
    String? email,
    File? imageFile,
  }) async {
    try {
      final userProfile = await _remoteDatasource.editUserProfile(
        firstName: firstname,
        lastName: lastName,
        username: username,
        email: email,
        imageFile: imageFile,
      );
      return userProfile.toEntity();
    } catch (e) {
      print("error editing user profile(repo): $e");
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getContact() async {
    try {
      return await _remoteDatasource.getContact();
    } catch (e) {
      print("Error get contact (repo): $e");
      rethrow;
    }
  }
}
