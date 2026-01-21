import 'package:get/get.dart';
import 'package:pak_tani/src/features/notification/application/services/notification_service.dart';
import 'package:pak_tani/src/features/notification/presentation/controllers/notification_screen_controller.dart';

/// Bindings for the notification feature.
///
/// Registers presentation controllers and other feature-scoped
/// dependencies into GetX. Use this binding when navigating to
/// notification-related routes to ensure required dependencies are
/// lazily created.
class NotificationBindings extends Bindings {
  @override
  /// Registers feature dependencies with GetX's dependency manager.
  ///
  /// The `NotificationScreenController` is registered lazily and will be
  /// recreated if removed (`fenix: true`).
  void dependencies() {
    Get.lazyPut<NotificationScreenController>(
      () => NotificationScreenController(Get.find<NotificationService>()),
      fenix: true,
    );
  }
}
