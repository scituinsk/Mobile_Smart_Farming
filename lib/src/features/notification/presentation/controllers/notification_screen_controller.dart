import 'package:get/get.dart';
import 'package:pak_tani/src/core/utils/my_snackbar.dart';
import 'package:pak_tani/src/features/notification/application/services/notification_service.dart';
import 'package:pak_tani/src/features/notification/domain/entities/notification_item.dart';

/// Controller for the notification screen.
///
/// Bridges UI interactions to the `NotificationService`, exposing reactive
/// getters used by the presentation layer and providing methods to refresh,
/// filter, and mark notifications as read. Errors are surfaced via
/// `MySnackbar` for user feedback.
class NotificationScreenController extends GetxController {
  /// Service responsible for notification data and operations.
  final NotificationService notificationService;

  NotificationScreenController(this.notificationService);

  /// Proxy to the service loading state (`true` while loading).
  RxBool get isLoading => notificationService.isLoading;

  /// The list of notifications currently visible to the UI (may be
  /// filtered by unread state).
  RxList<NotificationItem> get notificationItems =>
      notificationService.filteredNotificationItems;

  /// When `true`, the UI should display only unread notifications.
  RxBool get isShowUnread => notificationService.isShowUnread;

  @override
  /// Loads notifications when the controller initializes.
  void onInit() async {
    super.onInit();
    try {
      await notificationService.loadAllNotificationItems();
      filterNotification();
    } catch (e) {
      MySnackbar.error(message: e.toString());
    }
  }

  /// Refreshes the notification list by forcing a reload from the service.
  Future<void> refreshNotificationItems() async {
    try {
      await notificationService.loadAllNotificationItems(refresh: true);
      filterNotification();
    } catch (e) {
      print("error refresh notification (controller): $e");
      MySnackbar.error(message: e.toString());
    }
  }

  /// Applies the current filter selection (all or unread) to the visible
  /// notification list.
  void filterNotification() {
    notificationService.filterNotification();
    print("filtering notification");
  }

  /// Marks all notifications as read. Errors are shown via snackbar.
  void markReadAllNotification() async {
    try {
      await notificationService.markReadAllNotifications();
      filterNotification();
    } catch (e) {
      MySnackbar.error(message: e.toString());
    }
  }

  /// Marks a single notification (by `id`) as read and updates the UI.
  void markReadNotification(int id) async {
    try {
      await notificationService.markReadNotificationItem(id);
    } catch (e) {
      MySnackbar.error(message: e.toString());
    }
  }
}
