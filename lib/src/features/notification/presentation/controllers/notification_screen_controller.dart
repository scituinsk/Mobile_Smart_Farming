import 'package:get/get.dart';
import 'package:pak_tani/src/core/utils/my_snackbar.dart';
import 'package:pak_tani/src/features/notification/application/services/notification_service.dart';
import 'package:pak_tani/src/features/notification/domain/entities/notification_item.dart';

class NotificationScreenController extends GetxController {
  final NotificationService notificationService;
  NotificationScreenController(this.notificationService);

  RxBool get isLoading => notificationService.isLoading;

  RxList<NotificationItem> get notificationItems =>
      notificationService.notificationItems;

  Future<void> refreshNotificationItems() async {
    try {
      await notificationService.loadAllNotificationItems(refresh: true);
    } catch (e) {
      print("error refresh notification (controller): $e");
      MySnackbar.error(message: e.toString());
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    try {
      await notificationService.loadAllNotificationItems();
    } catch (e) {
      MySnackbar.error(message: e.toString());
    }
  }
}
