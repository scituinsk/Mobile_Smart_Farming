import 'package:get/get.dart';
import 'package:pak_tani/src/features/onboarding/presentation/controllers/onboard_screen_controller.dart';

class OnboardScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnboardScreenController());
  }
}
