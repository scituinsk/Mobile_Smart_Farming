import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/features/auth/application/services/auth_services.dart';
import 'package:pak_tani/src/features/auth/domain/entities/user.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  RxBool get isLoading => _authService.isLoading;
  RxBool get isLoggedIn => _authService.isLoggedIn;
  Rx<User?> get currentUser => _authService.currentUser;

  Future<void> login(String email, String password) async {
    try {
      await _authService.login(email, password);

      Get.offAllNamed(RouteNamed.mainPage);
      Get.snackbar("Success", "Login berhasil");
    } catch (e) {
      print("error login auth controller:  $e");
      Get.snackbar("error", e.toString());
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

      Get.snackbar("Success", "Register berhasil! silahkan login");
      Get.back();
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();

      Get.offAllNamed(RouteNamed.loginPage);
      Get.snackbar("Success", "Logout berhasil");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
