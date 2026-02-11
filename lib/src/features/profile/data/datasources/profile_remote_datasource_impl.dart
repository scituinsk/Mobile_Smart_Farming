import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/core/utils/log_utils.dart';
import 'package:pak_tani/src/features/profile/data/models/user_model.dart';
import 'package:pak_tani/src/features/profile/domain/datasources/profile_remote_datasource.dart';
import 'package:path/path.dart' as path;

class ProfileRemoteDatasourceImpl extends ProfileRemoteDatasource {
  final ApiService _apiService;
  ProfileRemoteDatasourceImpl(this._apiService);

  @override
  Future<UserModel?> getUserProfile() async {
    final response = await _apiService.get("/user/me");

    final responseData = response.data["data"] as Map<String, dynamic>;
    LogUtils.d("current user: $responseData");
    return UserModel.fromJson(responseData);
  }

  @override
  Future<UserModel> editUserProfile({
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    File? imageFile,
  }) async {
    Response response;
    if (imageFile != null) {
      final FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          imageFile.path,
          filename: path.basename(imageFile.path),
        ),
      });
      response = await _apiService.patch(
        "/user/me",
        data: formData,
        options: Options(headers: {"Content-Type": 'multipart/form-data'}),
      );
    } else {
      final requestData = <String, dynamic>{};
      if (firstName != null) requestData["first_name"] = firstName;
      if (lastName != null) requestData["last_name"] = lastName;
      if (username != null) requestData["username"] = username;
      if (email != null) requestData["email"] = email;

      response = await _apiService.patch("/user/me", data: requestData);
    }
    final responseData = response.data["data"] as Map<String, dynamic>;
    return UserModel.fromJson(responseData);
  }

  @override
  Future<Map<String, dynamic>> getContact() async {
    final response = await _apiService.get("/scit/contacts");
    final responseData = response.data["data"] as Map<String, dynamic>;
    return responseData;
  }
}
