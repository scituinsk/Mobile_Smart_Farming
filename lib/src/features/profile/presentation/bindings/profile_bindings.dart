import 'package:get/get.dart';
import 'package:pak_tani/src/features/auth/application/services/auth_services.dart';
import 'package:pak_tani/src/features/profile/application/services/profile_service.dart';
import 'package:pak_tani/src/features/profile/presentation/controllers/profile_controller.dart';

class ProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        Get.find<AuthService>(),
        Get.find<ProfileService>(),
      ),
      fenix: true,
    );
  }
}
