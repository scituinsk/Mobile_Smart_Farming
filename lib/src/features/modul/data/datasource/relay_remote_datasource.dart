import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/features/modul/data/models/group_relay_model.dart';
import 'package:pak_tani/src/features/modul/data/models/relay_model.dart';

abstract class RelayRemoteDatasource {
  Future<List<RelayModel>?> getListRelay(String serialId);
  Future<RelayModel> editRelay(
    int pin,
    String serialId, {
    String? name,
    int? groupId,
  });
  Future<List<GroupRelayModel>> getListGroup(String serialId);
  Future<GroupRelayModel> editGroup(String id, String name);
  Future<void> deleteGroup(String id);
}

class RelayRemoteDatasourceImpl implements RelayRemoteDatasource {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<List<RelayModel>?> getListRelay(String serialId) async {
    final Response response = await _apiService.get(
      "/iot/device/$serialId/pin/",
    );
    final responseData = response.data["data"] as List<dynamic>;

    return responseData
        .map((json) => RelayModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<RelayModel> editRelay(
    int pin,
    String serialId, {
    String? name,
    int? groupId,
  }) async {
    Response response;

    final FormData formData = FormData.fromMap({
      if (name != null) "name": name,
      if (groupId != null) "group": groupId,
    });

    response = await _apiService.patch(
      "/iot/device/$serialId/pin/$pin/",
      data: formData,
    );

    final responseData = response.data["data"] as Map<String, dynamic>;

    return RelayModel.fromJson(responseData);
  }

  @override
  Future<List<GroupRelayModel>> getListGroup(String serialId) async {
    final Response response = await _apiService.get(
      "/iot/device/$serialId/groups/",
    );

    final responseData = response.data["data"] as List<dynamic>;

    return responseData.map((json) => GroupRelayModel.fromJson(json)).toList();
  }

  @override
  Future<GroupRelayModel> editGroup(String id, String name) async {
    // kemungkinan akan ada perubahan
    final Response response = await _apiService.put(
      "/schedule/groups/$id/",
      data: {"name": name},
    );

    final responseData = response.data["data"] as Map<String, dynamic>;
    return GroupRelayModel.fromJson(responseData);
  }

  @override
  Future<void> deleteGroup(String id) async {
    await _apiService.delete("/schedule/groups/$id/");
  }
}
