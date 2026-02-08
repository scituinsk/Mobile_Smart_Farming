import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/utils/my_snackbar.dart';
import 'package:pak_tani/src/features/auth/application/services/auth_services.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  RxBool get isLoading => _authService.isLoading;
  RxBool get isLoggedIn => _authService.isLoggedIn;

  Future<void> login(String email, String password) async {
    try {
      await _authService.login(email, password);

      Get.offAllNamed(RouteNames.mainPage);
      MySnackbar.success(message: "login_success".tr);
    } catch (e) {
      print("error login auth controller:  $e");
      MySnackbar.error(message: e.toString());
    }
  }

  Future<void> register({
    required String firstName,
    String? lastName,
    required String username,
    required String email,
    required String password1,
    required String password2,
  }) async {
    try {
      await _authService.register(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        password1: password1,
        password2: password2,
      );

      Get.back();
      MySnackbar.success(message: "register_success".tr);
    } catch (e) {
      print(e);
      MySnackbar.error(message: e.toString());
    }
  }
}
