import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:dio/dio.dart';
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/features/modul/data/models/modul_model.dart';

abstract class ModulRemoteDatasource {
  Future<List<ModulModel>?> getListDevices();
  Future<ModulModel?> getDevice(String id);
  Future<ModulModel?> editDevice(
    String id, {
    String? name,
    String? description,
    String? imagePath,
  });
  Future<void> deleteDeviceFromUser(String id);
}

class ModulRemoteDatasourceImpl implements ModulRemoteDatasource {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<List<ModulModel>?> getListDevices() async {
    final response = await _apiService.get('/iot/device/list/');
    final responseData = response.data['data'] as List<dynamic>;

    return responseData
        .map((json) => ModulModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ModulModel?> getDevice(String id) async {
    final response = await _apiService.get('/iot/device/$id/');
    final responseData = response.data['data'] as Map<String, dynamic>;

    return ModulModel.fromJson(responseData);
  }

  @override
  Future<ModulModel?> editDevice(
    String id, {
    String? name,
    String? description,
    String? imagePath,
  }) async {
    Response response;
    if (imagePath != null && imagePath.isNotEmpty) {
      final formData = FormData.fromMap({
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
      });

      response = await _apiService.patch(
        '/iot/device/$id',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
    } else {
      final requestData = <String, dynamic>{};

      if (name != null) requestData['name'] = name;
      if (description != null) requestData['description'] = description;

      response = await _apiService.patch('/iot/device/$id/', data: requestData);
    }
    final responseData = response.data['data'] as Map<String, dynamic>;
    return ModulModel.fromJson(responseData);
  }

  @override
  Future<void> deleteDeviceFromUser(String id) async {
    await _apiService.delete('/iot/device/$id/');
  }
}
