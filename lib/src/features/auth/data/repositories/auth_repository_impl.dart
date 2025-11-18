import 'package:get/get.dart';
import 'package:pak_tani/src/core/errors/api_exception.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';
import 'package:pak_tani/src/features/auth/domain/datasources/auth_remote_datasource.dart';
import 'package:pak_tani/src/features/auth/domain/entities/user.dart';
import 'package:pak_tani/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  Future<User> login(String email, String password) async {
    try {
      //call api for login
      final userModel = await remoteDatasource.login(email, password);

      return userModel.toEntity();
    } on ApiException {
      rethrow;
    } catch (e) {
      print('Unexpected error in AuthRepository.login: $e');
      throw UnexpectedException(
        message: 'Terjadi kesalahan saat memproses data login.',
      );
    }
  }

  @override
  Future<void> register({
    required String firstName,
    String? lastName,
    required String username,
    required String email,
    required String password1,
    required String password2,
  }) async {
    try {
      await remoteDatasource.register(
        firstName: firstName,
        username: username,
        email: email,
        password1: password1,
        password2: password2,
      );
    } on ApiException {
      // ✅ Lakukan hal yang sama untuk semua method repository
      rethrow;
    } catch (e) {
      print('Unexpected error in AuthRepository.register: $e');
      throw UnexpectedException(
        message: 'Terjadi kesalahan saat memproses data registrasi.',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      final StorageService storage = Get.find<StorageService>();
      final refreshToken = await storage.readSecure('refresh_token');

      if (refreshToken != null) {
        try {
          await remoteDatasource.logout(refreshToken);
        } catch (e) {
          print('API logout gagal: $e');
        }
      }

      await storage.deleteSecure('access_token');
      await storage.deleteSecure('refresh_token');
    } on ApiException {
      rethrow;
    } catch (e) {
      print('Unexpected error in AuthRepository.logout: $e');
      throw UnexpectedException(message: 'Terjadi kesalahan saat logout.');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userModel = await remoteDatasource.getCurrentUser();
      if (userModel != null) {
        return userModel.toEntity();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> requestPasswordReset(String email) {
    // TODO: implement requestPasswordReset
    throw UnimplementedError();
  }
}
