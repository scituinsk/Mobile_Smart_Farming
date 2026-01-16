/// Dependencies bindings for main navigation

library;

import 'package:get/get.dart';
import 'package:pak_tani/src/core/controllers/main_navigation_controller.dart';

/// Bindings class for Main Navigation.
class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainNavigationController(), permanent: true);
  }
}
