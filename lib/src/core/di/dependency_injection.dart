/// Dependency injection for app initialization.
/// Put all permanent and starter controllers, services, and datasources.

library;

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

/// Dependency class for dependency injection.
class DependencyInjection {
  /// Initializes services, controllers, and datasources.
  /// This includes core service, datasources, repositories, use cases, business service, and presentation controllers.
  static Future<void> init() async {
    print('🔄 Starting dependency injection...');

    try {
      Get.put(ConnectivityService(), permanent: true);

      await _initCoreServices();
      await _initDataSources();
      await _initRepositories();
      await _initUseCases();
      await _initServices();
      await _initController();

      print('✅ All dependencies initialized successfully!');
    } catch (e) {
      print('❌ Dependency injection failed: $e');
      rethrow;
    }
  }

  /// Initialize storage service, api service, and websocket service
  static Future<void> _initCoreServices() async {
    try {
      print('   - Initializing StorageService...');
      Get.put<StorageService>(StorageService(), permanent: true);
      print('   ✅ StorageService ready');

      print('   - Initializing ApiService...');
      Get.put<ApiService>(ApiService(), permanent: true);
      print('   ✅ ApiService ready');

      print('   - Initializing websocket...');
      Get.put<WebSocketService>(WebSocketService(), permanent: true);
      print('   ✅ wsService ready');
    } catch (e) {
      rethrow;
    }
  }

  /// Initialize auth data source
  static Future<void> _initDataSources() async {
    try {
      print('   - Registering Auth DataSources...');
      Get.lazyPut<AuthRemoteDatasource>(() {
        return AuthRemoteDatasourceImpl();
      }, fenix: true);
      print('   ✅ Auth DataSources registered');
    } catch (e) {
      rethrow;
    }
  }

  /// Initialize auth repository
  static Future<void> _initRepositories() async {
    try {
      print('   - Registering Repositories...');
      Get.lazyPut<AuthRepository>(() {
        return AuthRepositoryImpl(
          remoteDatasource: Get.find<AuthRemoteDatasource>(),
        );
      }, fenix: true);
      print('   ✅ Repositories registered');
    } catch (e) {
      rethrow;
    }
  }

  /// Initialize login, register, logout, and user use cases.
  static Future<void> _initUseCases() async {
    try {
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
    } catch (e) {
      rethrow;
    }
  }

  /// Initialize auth services
  static Future<void> _initServices() async {
    try {
      print('   - Initializing AuthService...');

      // Use putAsync to ensure proper initialization sequence
      await Get.putAsync<AuthService>(() async {
        final authService = AuthService();
        // Wait for AuthService initialization to complete
        await authService.onInit();
        return authService;
      }, permanent: true);

      print('   ✅ AuthService ready');
    } catch (e) {
      rethrow;
    }
  }

  /// initialize auth controller
  static Future<void> _initController() async {
    try {
      print('   - Registering Presentation Controllers...');
      Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
      print('   ✅ Presentation Controllers registered');
    } catch (e) {
      rethrow;
    }
  }
}
