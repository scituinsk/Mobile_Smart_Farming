/// Dependencies bindings for main navigation

library;

import 'package:get/get.dart';
import 'package:pak_tani/src/core/controllers/main_navigation_controller.dart';
import 'package:pak_tani/src/features/notification/application/services/notification_service.dart';

/// Bindings class for Main Navigation.
class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainNavigationController(Get.find<NotificationService>()));
  }
}
