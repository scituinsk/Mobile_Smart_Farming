import 'package:get/get.dart';
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/core/services/connectivity_service.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';
import 'package:pak_tani/src/core/services/web_socket_service.dart';
import 'package:pak_tani/src/features/auth/application/services/auth_services.dart';
import 'package:pak_tani/src/features/auth/application/use_cases/get_user_use_case.dart';
import 'package:pak_tani/src/features/auth/application/use_cases/login_use_case.dart';
import 'package:pak_tani/src/features/auth/application/use_cases/logout_use_case.dart';
import 'package:pak_tani/src/features/auth/application/use_cases/register_use_case.dart';
import 'package:pak_tani/src/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:pak_tani/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pak_tani/src/features/auth/domain/datasources/auth_remote_datasource.dart';
import 'package:pak_tani/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:pak_tani/src/features/auth/presentation/controller/auth_controller.dart';

class DependencyInjection {
  static Future<void> init() async {
    print('🔄 Starting dependency injection...');

    try {
      Get.put(ConnectivityService(), permanent: true);

      // ===== LAYER 1: CORE SERVICES =====
      print('   - Initializing StorageService...');
      final storageService = StorageService();
      await storageService.onInit();
      Get.put<StorageService>(storageService, permanent: true);
      print('   ✅ StorageService ready');

      print('   - Initializing ApiService...');
      final apiService = ApiService();
      await apiService.onInit();
      Get.put<ApiService>(apiService, permanent: true);
      print('   ✅ ApiService ready');

      print('   - Initializing websocket...');
      Get.put<WebSocketService>(WebSocketService(), permanent: true);
      print('   ✅ wsService ready');

      // ===== LAYER 2: DATA SOURCES =====
      print('   - Registering Auth DataSources...');
      Get.lazyPut<AuthRemoteDatasource>(() {
        return AuthRemoteDatasourceImpl();
      }, fenix: true);
      print('   ✅ Auth DataSources registered');

      // ===== LAYER 3: REPOSITORIES =====
      print('   - Registering Repositories...');
      Get.lazyPut<AuthRepository>(() {
        return AuthRepositoryImpl(
          remoteDatasource: Get.find<AuthRemoteDatasource>(),
        );
      }, fenix: true);
      print('   ✅ Repositories registered');

      // ===== LAYER 4: USE CASES =====
      print('   - Registering Use Cases...');
      Get.lazyPut<LoginUseCase>(() => LoginUseCase(Get.find<AuthRepository>()));
      Get.lazyPut<RegisterUseCase>(
        () => RegisterUseCase(Get.find<AuthRepository>()),
      );
      Get.lazyPut<LogoutUseCase>(
        () => LogoutUseCase(Get.find<AuthRepository>()),
      );
      Get.lazyPut<GetUserUseCase>(
        () => GetUserUseCase(Get.find<AuthRepository>()),
      );
      print('   ✅ Use Cases registered');

      // ===== LAYER 5: BUSINESS SERVICES =====
      print('   - Initializing AuthService...');

      // ✅ Use putAsync to ensure proper initialization sequence
      await Get.putAsync<AuthService>(() async {
        final authService = AuthService();
        // ✅ Wait for AuthService initialization to complete
        await authService.onInit();
        return authService;
      }, permanent: true);

      print('   ✅ AuthService ready');

      // ===== LAYER 6: PRESENTATION CONTROLLERS =====
      print('   - Registering Presentation Controllers...');
      Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
      print('   ✅ Presentation Controllers registered');

      print('✅ All dependencies initialized successfully!');

      Get.put(WebSocketService(), permanent: true);
    } catch (e) {
      print('❌ Dependency injection failed: $e');
      rethrow;
    }
  }

  static bool get isReady {
    try {
      // ✅ Check core dependencies
      Get.find<StorageService>();
      Get.find<ApiService>();

      // ✅ Check if AuthService exists and is ready
      if (!Get.isRegistered<AuthService>()) {
        print('⏳ AuthService not registered yet');
        return false;
      }

      final authService = Get.find<AuthService>();

      // ✅ Check if AuthService is still initializing
      if (authService.isLoading.value) {
        print('⏳ AuthService still initializing...');
        return false;
      }

      // ✅ Check if AuthService initialization is complete
      if (!authService.isReady) {
        print('⏳ AuthService not ready yet');
        return false;
      }

      return true;
    } catch (e) {
      print('❌ Dependency check failed: $e');
      return false;
    }
  }

  //
}
