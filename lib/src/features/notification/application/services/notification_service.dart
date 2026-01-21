import 'package:get/get.dart';
import 'package:pak_tani/src/features/notification/domain/entities/notification_item.dart';
import 'package:pak_tani/src/features/notification/domain/repositories/notification_repository.dart';

class NotificationService extends GetxService {
  final NotificationRepository _repository;
  NotificationService(this._repository);

  final RxList<NotificationItem> notificationItems = <NotificationItem>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> loadAllNotificationItems({bool refresh = false}) async {
    if (refresh) {
      notificationItems.clear();
    }

    isLoading.value = true;
    try {
      final notificationList = await _repository.getListAllNotifications();
      if (notificationList != null) {
        notificationItems.assignAll(notificationList);
        print(
          "notification item: ${notificationItems.map((element) => element.id)}",
        );
      } else {
        notificationItems.clear();
      }
    } catch (e) {
      print("error load notifications(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markReadNotificationItem(int id) async {
    try {
      final notificationItem = await _repository.markReadNotification(id);
      final index = notificationItems.indexWhere(
        (element) => element.id == notificationItem.id,
      );
      notificationItems[index] = notificationItem;
    } catch (e) {
      print("Error mark read notification(service): $e");
      rethrow;
    }
  }

  Future<void> markReadAllNotifications() async {
    try {
      await _repository.markReadAllNotifications();
      notificationItems.assignAll(
        notificationItems.map((item) => item.copyWith(readStatus: true)),
      );
    } catch (e) {
      print("Error mark read all notifications: $e");
      rethrow;
    }
  }
}
