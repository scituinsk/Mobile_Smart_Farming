import 'package:dio/dio.dart';
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/features/notification/data/models/notification_item_model.dart';
import 'package:pak_tani/src/features/notification/domain/datasources/notification_remote_datasource.dart';

/// Remote datasource implementation for notifications.
///
/// Uses an `ApiService` to call backend endpoints related to user
/// notifications. Responsible for fetching the notification list and
/// marking notifications as read (single or all). Responses are parsed into
/// `NotificationItemModel` instances.
class NotificationRemoteDatasourceImpl extends NotificationRemoteDatasource {
  final ApiService _apiService;
  NotificationRemoteDatasourceImpl(this._apiService);

  /// Fetches all notifications for the current user.
  ///
  /// Sends a GET request to `/user/notifications` and maps the response data
  /// into a list of `NotificationItemModel`. The method returns the parsed
  /// list or throws if the network call fails or the response format is
  /// unexpected.
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

  /// Marks all notifications as read for the current user.
  ///
  /// Sends a PATCH request to `/user/notification/read-all`. Completes
  /// normally on success or throws on failure.
  @override
  Future<void> markAllNotifications() async {
    await _apiService.patch("/user/notification/read-all");
  }

  /// Marks a single notification as read and returns the updated item.
  ///
  /// Sends a PATCH request to `/user/notification/read/{id}` and parses the
  /// returned notification payload into a `NotificationItemModel`.
  @override
  Future<NotificationItemModel> markReadNotification(String id) async {
    final Response response = await _apiService.patch(
      "/user/notification/read/$id",
    );
    final responseData = response.data["data"] as Map<String, dynamic>;
    return NotificationItemModel.fromJson(responseData);
  }
}
