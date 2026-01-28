import 'dart:io';

import 'package:pak_tani/src/features/profile/data/models/user_model.dart';

abstract class ProfileRemoteDatasource {
  Future<UserModel?> getUserProfile();
  Future<UserModel> editUserProfile({
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    File? imageFile,
  });
  Future<Map<String, dynamic>> getContact();
}
