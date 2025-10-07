import 'package:get/get.dart';
import 'package:pak_tani/src/features/auth/application/use_cases/get_user_use_case.dart';
import 'package:pak_tani/src/features/auth/application/use_cases/login_use_case.dart';
import 'package:pak_tani/src/features/auth/application/use_cases/logout_use_case.dart';
import 'package:pak_tani/src/features/auth/application/use_cases/register_use_case.dart';
import 'package:pak_tani/src/features/auth/domain/entities/user.dart';

class AuthService extends GetxService {
  final LoginUseCase _loginUseCase = Get.find<LoginUseCase>();
  final RegisterUseCase _registerUseCase = Get.find<RegisterUseCase>();
  final LogoutUseCase _logoutUseCase = Get.find<LogoutUseCase>();
  final GetUserUseCase _getUserUseCase = Get.find<GetUserUseCase>();

  final RxBool isLoading = true.obs;
  final RxBool isLoggedIn = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    _checkAuthenticationStatus();
  }

  Future<void> _checkAuthenticationStatus() async {
    isLoading.value = true;

    try {
      final user = await _getUserUseCase.execute();
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

  Future<User?> login(String email, String password) async {
    isLoading.value = true;
    try {
      await _loginUseCase.execute(email, password);
      final user = await _getUserUseCase.execute();

      currentUser.value = user;
      isLoggedIn.value = true;

      return user;
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
      await _registerUseCase.execute(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        password1: password1,
        password2: password2,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _logoutUseCase.execute();
      currentUser.value = null;
      isLoggedIn.value = false;
    } catch (e) {
      print('logout error: $e');
      rethrow;
    }
  }
}
