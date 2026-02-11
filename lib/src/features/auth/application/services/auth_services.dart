import 'package:get/get.dart';
import 'package:pak_tani/src/core/services/web_socket_service.dart';
import 'package:pak_tani/src/core/utils/log_utils.dart';
import 'package:pak_tani/src/features/auth/application/use_cases/get_user_use_case.dart';
import 'package:pak_tani/src/features/auth/application/use_cases/login_use_case.dart';
import 'package:pak_tani/src/features/auth/application/use_cases/logout_use_case.dart';
import 'package:pak_tani/src/features/auth/application/use_cases/register_use_case.dart';
import 'package:pak_tani/src/features/modul/domain/repositories/modul_repository.dart';
import 'package:pak_tani/src/features/profile/application/services/profile_service.dart';
import 'package:pak_tani/src/features/profile/domain/entities/user.dart';

class AuthService extends GetxService {
  final WebSocketService _wsService;
  final ProfileService _profileService;
  AuthService(this._wsService, this._profileService);

  final LoginUseCase _loginUseCase = Get.find<LoginUseCase>();
  final RegisterUseCase _registerUseCase = Get.find<RegisterUseCase>();
  final LogoutUseCase _logoutUseCase = Get.find<LogoutUseCase>();
  final GetUserUseCase _getUserUseCase = Get.find<GetUserUseCase>();

  // final AuthRepository _authRepository = Get.find<AuthRepository>();

  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxBool isInitialized = false.obs;

  /// Indicates if the AuthService has completed its initialization
  bool get isReady => isInitialized.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    isInitialized.value = true;
    LogUtils.d(
      '✅ AuthService initialized (instance: $hashCode) - isReady: $isReady',
    );
  }

  void debugInfo() {
    LogUtils.d('🔍 AuthService Debug Info:');
    LogUtils.d('   - Instance hash: $hashCode');
    LogUtils.d('   - isInitialized: ${isInitialized.value}');
    LogUtils.d('   - isReady: $isReady');
    LogUtils.d('   - isLoggedIn: ${isLoggedIn.value}');
  }

  Future<void> checkAuthenticationStatus() async {
    if (isLoading.value) return;

    isLoading.value = true;
    LogUtils.d('🔍 Checking authentication status...');

    try {
      final user = await _getUserUseCase.execute();
      if (user != null) {
        isLoggedIn.value = true;
        _profileService.currentUser.value = user;
        LogUtils.d('user logged in: ${user.username}');
      } else {
        isLoggedIn.value = false;
        LogUtils.d('User not logged in');
      }
    } catch (e) {
      LogUtils.e('init auth error', e);
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

      _profileService.currentUser.value = user;
      isLoggedIn.value = true;

      return user;
    } catch (e) {
      LogUtils.e("login gagal", e);
      isLoggedIn.value = false;
      rethrow;
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
    } catch (e) {
      LogUtils.e("register error", e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      // Close all modul sream before log out
      await _wsService.closeAllDeviceStreams();
      final modulRepo = Get.find<ModulRepository>();
      await modulRepo.clearLocalModul();

      await _logoutUseCase.execute();
      _profileService.currentUser.value = null;
      isLoggedIn.value = false;
    } catch (e) {
      LogUtils.e('logout error', e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
