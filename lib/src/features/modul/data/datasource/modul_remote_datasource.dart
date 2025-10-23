import 'dart:io';

import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:dio/dio.dart';
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/features/modul/data/models/modul_model.dart';
import 'package:path/path.dart' as p;

abstract class ModulRemoteDatasource {
  Future<List<ModulModel>?> getListModuls();
  Future<ModulModel?> getModul(String id);
  Future<ModulModel?> editModul(
    String id, {
    String? name,
    String? password,
    String? description,
    File? imageFile,
  });
  Future<void> deleteModulFromUser(String id);
  Future<ModulModel?> addModulToUser(String id, String password);
}

class ModulRemoteDatasourceImpl implements ModulRemoteDatasource {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<List<ModulModel>?> getListModuls() async {
    final response = await _apiService.get('/iot/device/list/');
    final responseData = response.data['data'] as List<dynamic>;

    return responseData
        .map((json) => ModulModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ModulModel?> getModul(String id) async {
    final response = await _apiService.get('/iot/device/$id/');
    final responseData = await response.data['data'] as Map<String, dynamic>;

    return ModulModel.fromJson(responseData);
  }

  @override
  Future<ModulModel?> addModulToUser(String id, String password) async {
    final response = await _apiService.post(
      '/iot/device/$id/',
      data: {"password": password},
    );

    final responseData = await response.data['data'] as Map<String, dynamic>;

    return ModulModel.fromJson(responseData);
  }

  @override
  Future<ModulModel?> editModul(
    String id, {
    String? name,
    String? password,
    String? description,
    File? imageFile,
  }) async {
    Response response;
    if (imageFile != null) {
      final formData = FormData.fromMap({
        if (name != null) 'name': name,
        if (password != null) 'password': password,
        if (description != null) 'descriptions': description,
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: p.basename(imageFile.path),
        ),
      });

      response = await _apiService.patch(
        '/iot/device/$id/',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
    } else {
      final requestData = <String, dynamic>{};

      if (name != null) requestData['name'] = name;
      if (password != null) requestData['password'] = password;
      if (description != null) requestData['descriptions'] = description;

      response = await _apiService.patch('/iot/device/$id/', data: requestData);
    }
    final responseData = response.data['data'] as Map<String, dynamic>;
    return ModulModel.fromJson(responseData);
  }

  @override
  Future<void> deleteModulFromUser(String id) async {
    await _apiService.delete('/iot/device/$id/');
  }
}
