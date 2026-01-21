import 'package:dio/dio.dart';
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/features/notification/data/models/notification_item_model.dart';
import 'package:pak_tani/src/features/notification/domain/datasources/notification_remote_datasource.dart';

class NotificationRemoteDatasourceImpl extends NotificationRemoteDatasource {
  final ApiService _apiService;
  NotificationRemoteDatasourceImpl(this._apiService);

  @override
  Future<List<NotificationItemModel>?> getListAllNotifications() async {
    final Response response = await _apiService.get("/user/notifications");
    final responseData = response.data["data"] as List<dynamic>;

    return responseData
        .map(
          (json) =>
              NotificationItemModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<void> markAllNotifications() async {
    await _apiService.patch("/user/notification/read-all");
  }

  @override
  Future<NotificationItemModel> markReadNotification(String id) async {
    final Response response = await _apiService.patch(
      "/user/notification/read/$id",
    );
    final responseData = response.data["data"] as Map<String, dynamic>;
    return NotificationItemModel.fromJson(responseData);
  }
}
