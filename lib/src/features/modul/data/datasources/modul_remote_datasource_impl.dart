import 'dart:io';

import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:dio/dio.dart';
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/features/modul/data/models/modul_model.dart';
import 'package:pak_tani/src/features/modul/domain/datasources/modul_remote_datasource.dart';
import 'package:path/path.dart' as p;

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
  Future<ModulModel?> getModul(String serialId) async {
    final response = await _apiService.get('/iot/device/$serialId/');
    final responseData = await response.data['data'] as Map<String, dynamic>;

    return ModulModel.fromJson(responseData);
  }

  @override
  Future<ModulModel?> addModulToUser(String serialId, String password) async {
    final response = await _apiService.post(
      '/iot/device/$serialId/',
      data: {"password": password},
    );

    final responseData = await response.data['data'] as Map<String, dynamic>;

    return ModulModel.fromJson(responseData);
  }

  @override
  Future<ModulModel?> editModul(
    String serialId, {
    String? name,
    String? password,
    String? description,
    File? imageFile,
  }) async {
    Response response;
    if (imageFile != null) {
      final FormData formData = FormData.fromMap({
        if (name != null) 'name': name,
        if (password != null) 'password': password,
        if (description != null) 'descriptions': description,
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: p.basename(imageFile.path),
        ),
      });

      response = await _apiService.patch(
        '/iot/device/$serialId/',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
    } else {
      final requestData = <String, dynamic>{};

      if (name != null) requestData['name'] = name;
      if (password != null) requestData['password'] = password;
      if (description != null) requestData['descriptions'] = description;

      response = await _apiService.patch(
        '/iot/device/$serialId/',
        data: requestData,
      );
    }
    final responseData = response.data['data'] as Map<String, dynamic>;
    return ModulModel.fromJson(responseData);
  }

  @override
  Future<void> deleteModulFromUser(String serialId) async {
    await _apiService.delete('/iot/device/$serialId/');
  }
}
