import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/features/auth/domain/entities/user.dart';
import 'package:pak_tani/src/features/auth/domain/repositories/auth_repository.dart';

class AuthController extends GetxService {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final RxBool isLoading = true.obs;
  final RxBool isLoggedIn = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    isLoading.value = true;

    try {
      // final user = await (_authRepository as AuthRepositoryImpl)
      //     .getCurrentUser();
      final user = null;

      if (user != null) {
        currentUser.value = user;
        isLoggedIn.value = true;
        print('user logged in: ${user.username}');
      } else {
        isLoggedIn.value = false;
        print('User not logged in');
      }
    } catch (e) {
      print('init auth error: $e');
      isLoggedIn.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      print("email: $email, password: $password");
      final user = await _authRepository.login(email, password);
      currentUser.value = user;
      isLoggedIn.value = true;

      Get.offAllNamed(RouteNamed.mainPage);
      Get.snackbar("Success", "login berhasil");
    } catch (e) {
      print(e);
      Get.snackbar("Error", "$e");
    } finally {
      isLoading.value = false;
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
    isLoading.value = true;
    try {
      await _authRepository.register(
        firstName: firstName,
        username: username,
        email: email,
        password1: password1,
        password2: password2,
      );

      Get.snackbar("Success", "Registrasi berhasil! Silakan login.");
      Get.offNamed(RouteNamed.loginPage);
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Registrasi gagal: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      currentUser.value = null;
      isLoggedIn.value = false;
      Get.offAllNamed(RouteNamed.loginPage);
      Get.snackbar("Success", "Logout berhasil");
    } catch (e) {
      Get.snackbar("Error", "Logout gagal: $e");
    }
  }
}
