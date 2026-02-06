import 'dart:io';

import 'package:pak_tani/src/features/profile/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<User?> getUserProfile();
  Future<User> editUserProfile({
    String? firstname,
    String? lastName,
    String? username,
    String? email,
    File? imageFile,
  });
  Future<Map<String, dynamic>> getContact();
}
