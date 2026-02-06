import 'package:get/get.dart';
import 'package:pak_tani/src/features/notification/domain/entities/notification_item.dart';
import 'package:pak_tani/src/features/notification/domain/repositories/notification_repository.dart';

/// Notification service.
///
/// Manages loading, filtering and updating notification items using a
/// provided `NotificationRepository`. Exposes reactive state (GetX `Rx` types)
/// so UI layers can observe changes such as the full notification list,
/// a filtered list, loading state, and unread count.
///
/// Typical usage:
/// ```dart
/// final service = NotificationService(myRepository);
/// Get.put(service);
/// // Observe `service.notificationItems`, `service.filteredNotificationItems`,
/// // `service.isLoading` and `service.unreadCount` in the UI.
/// ```

class NotificationService extends GetxService {
  final NotificationRepository _repository;
  NotificationService(this._repository);

  /// The canonical list of all notifications loaded from the repository.
  ///
  /// Sorted by `createdAt` (newest first) after loading.
  final RxList<NotificationItem> notificationItems = <NotificationItem>[].obs;

  /// `true` while notifications are being loaded from the repository.
  final RxBool isLoading = false.obs;

  /// The currently visible subset of notifications.
  ///
  /// Used to present either all notifications or a filtered view (for
  /// example unread-only). Mutating this list affects only the visible set,
  /// not the canonical `notificationItems` unless explicitly assigned.
  final RxList<NotificationItem> filteredNotificationItems =
      <NotificationItem>[].obs;

  /// Number of unread notifications (computed from `notificationItems`).
  final RxInt unreadCount = 0.obs;

  final RxBool isShowUnread = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load notifications immediately when the service is initialized.
    loadAllNotificationItems();
  }

  /// Loads all notifications from the repository.
  ///
  /// If [refresh] is `true`, clears existing lists before fetching. After a
  /// successful fetch the lists are sorted (newest first) and both
  /// `notificationItems` and `filteredNotificationItems` are updated.
  /// `isLoading` is set to `true` during the operation.
  Future<void> loadAllNotificationItems({bool refresh = false}) async {
    if (refresh) {
      notificationItems.clear();
      filteredNotificationItems.clear();
    }

    isLoading.value = true;
    try {
      final notificationList = await _repository.getListAllNotifications();
      if (notificationList != null) {
        notificationList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        notificationItems.assignAll(notificationList);
        filteredNotificationItems.assignAll(notificationList);
        updateUnreadCount();
      } else {
        notificationItems.clear();
        filteredNotificationItems.clear();
      }
    } catch (e) {
      print("error load notifications(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Marks a single notification as read using the repository and updates
  /// the local lists with the returned updated item.
  ///
  /// Throws if the repository call fails. Note: the method assumes the
  /// updated item exists in the current `notificationItems` list and writes
  /// the updated item at the same index in both lists.
  Future<void> markReadNotificationItem(int id) async {
    try {
      final notificationItem = await _repository.markReadNotification(id);
      final index = notificationItems.indexWhere(
        (element) => element.id == notificationItem.id,
      );
      notificationItems[index] = notificationItem;
      filteredNotificationItems[index] = notificationItem;

      updateUnreadCount();
    } catch (e) {
      print("Error mark read notification(service): $e");
      rethrow;
    }
  }

  /// Marks all notifications as read both remotely (via repository) and
  /// locally. After the repository call succeeds, the local lists are
  /// updated to reflect `readStatus: true` for every item and the unread
  /// count is refreshed.
  Future<void> markReadAllNotifications() async {
    try {
      await _repository.markReadAllNotifications();

      filteredNotificationItems.assignAll(
        notificationItems.map((item) => item.copyWith(readStatus: true)),
      );

      notificationItems.assignAll(
        filteredNotificationItems.map(
          (item) => item.copyWith(readStatus: true),
        ),
      );

      updateUnreadCount();

      print("mark read item: ${filteredNotificationItems.length}");
    } catch (e) {
      print("Error mark read all notifications: $e");
      rethrow;
    }
  }

  /// Filters the visible list to only unread notifications.
  void filterUnreadNotification() {
    filteredNotificationItems.assignAll(
      notificationItems.where((item) => !item.readStatus),
    );
  }

  /// Restores the visible list to show all notifications.
  void filterAllNotification() {
    filteredNotificationItems.assignAll(notificationItems);
  }

  /// Recomputes the `unreadCount` from the canonical `notificationItems`
  /// list.
  void updateUnreadCount() {
    unreadCount.value = notificationItems
        .where((element) => !element.readStatus)
        .length;

    print("unread notif: $unreadCount");
  }

  void filterNotification() {
    if (isShowUnread.value) {
      filteredNotificationItems.assignAll(
        notificationItems.where((item) => !item.readStatus),
      );
    } else {
      filteredNotificationItems.assignAll(notificationItems);
    }
  }
}
