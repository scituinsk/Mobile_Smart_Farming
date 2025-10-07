import 'package:get/get.dart';
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';
import 'package:pak_tani/src/features/auth/application/services/auth_services.dart';
import 'package:pak_tani/src/features/auth/application/use_cases/get_user_use_case.dart';
import 'package:pak_tani/src/features/auth/application/use_cases/login_use_case.dart';
import 'package:pak_tani/src/features/auth/application/use_cases/logout_use_case.dart';
import 'package:pak_tani/src/features/auth/application/use_cases/register_use_case.dart';
import 'package:pak_tani/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:pak_tani/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pak_tani/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:pak_tani/src/features/auth/presentation/controller/auth_controller.dart';

class DependencyInjection {
  static Future<void> init() async {
    // 1. Storage Service FIRST (no dependencies)
    print('   - Initializing StorageService...');
    final storageService = StorageService();
    await storageService.onInit();
    Get.put<StorageService>(storageService, permanent: true);
    print('   ✅ StorageService ready');

    // 2. API Service SECOND (depends on StorageService)
    print('   - Initializing ApiService...');
    final apiService = ApiService();
    await apiService.onInit();
    Get.put<ApiService>(apiService, permanent: true);
    print('   ✅ ApiService ready');

    Get.lazyPut<AuthRemoteDatasource>(() {
      return AuthRemoteDatasourceImpl();
    }, fenix: true);

    Get.lazyPut<AuthRepository>(() {
      return AuthRepositoryImpl(
        remoteDatasource: Get.find<AuthRemoteDatasource>(),
      );
    }, fenix: true);

    Get.lazyPut<LoginUseCase>(() => LoginUseCase(Get.find<AuthRepository>()));
    Get.lazyPut<RegisterUseCase>(
      () => RegisterUseCase(Get.find<AuthRepository>()),
    );
    Get.lazyPut<LogoutUseCase>(() => LogoutUseCase(Get.find<AuthRepository>()));
    Get.lazyPut<GetUserUseCase>(
      () => GetUserUseCase(Get.find<AuthRepository>()),
    );

    Get.putAsync<AuthService>(() async {
      final service = AuthService();
      await service.onInit();
      return service;
    });

    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }

  static bool get isReady {
    try {
      Get.find<StorageService>();
      Get.find<ApiService>();
      Get.find<AuthController>();
      return true;
    } catch (e) {
      return false;
    }
  }
}
