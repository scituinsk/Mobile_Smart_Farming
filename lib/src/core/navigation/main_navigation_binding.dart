import 'package:get/get.dart';
import 'package:pak_tani/src/core/navigation/main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainNavigationController(), permanent: true);
  }
}
