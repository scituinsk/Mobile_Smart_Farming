import 'dart:io';

import 'package:get/get.dart';
import 'package:pak_tani/src/core/utils/log_utils.dart';
import 'package:pak_tani/src/features/profile/domain/entities/user.dart';
import 'package:pak_tani/src/features/profile/domain/repositories/profile_repository.dart';

class ProfileService extends GetxService {
  final ProfileRepository _repository;
  ProfileService(this._repository);

  Rxn<User> currentUser = Rxn<User>(null);
  RxBool isLoading = false.obs;
  RxBool isLoadingSubmit = false.obs;
  RxMap<String, dynamic> contacts = RxMap<String, dynamic>();

  Future<void> loadUserProfile() async {
    isLoading.value = true;
    try {
      final user = await _repository.getUserProfile();
      if (user != null) {
        currentUser.value = user;
        LogUtils.d("first name: ${currentUser.value?.firstName}");
      }
      await _getContact();
    } catch (e) {
      LogUtils.e("failed to load userProfile(service)", e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editUserProfile({
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    File? imageFile,
  }) async {
    isLoadingSubmit.value = true;
    try {
      final userProfile = await _repository.editUserProfile(
        firstname: firstName,
        lastName: lastName,
        username: username,
        email: email,
        imageFile: imageFile,
      );
      currentUser.value = userProfile;
    } catch (e) {
      LogUtils.e("error editing user photo profile (service)", e);
      rethrow;
    } finally {
      isLoadingSubmit.value = false;
    }
  }

  Future<void> _getContact() async {
    try {
      final contact = await _repository.getContact();
      contacts.value = contact;
    } catch (e) {
      LogUtils.e("Error get contact (service)", e);
      rethrow;
    }
  }
}
