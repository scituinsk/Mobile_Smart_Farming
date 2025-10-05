import 'package:get/get.dart';
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';
import 'package:pak_tani/src/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login(String email, String password);
  Future<void> register({
    required String firstName,
    String? lastName,
    required String username,
    required String email,
    required String password1,
    required String password2,
  });
  Future<void> logout(String refreshToken);
  Future<void> refreshAccess(String refreshToken);
  Future<void> requestPasswordReset(String email);
}

class AuthREmoteDataSourceImpl implements AuthRemoteDatasource {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await _apiService.post(
      '/login',
      data: {'email': email, 'password': password},
    );

    //simpan accessToken dan refreshToken
    final accessToken = response.data['access'];
    final refreshToken = response.data['refresh'];
    await _storageService.writeSecure('access_token', accessToken);
    await _storageService.writeSecure('refresh_token', refreshToken);

    return UserModel.fromJson(response.data['user']);
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
    await _apiService.post(
      '/register',
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'password1': password1,
        'password2': password2,
      },
    );
  }

  @override
  Future<void> logout(String refreshToken) async {
    await _apiService.post('/logout', data: {'refresh': refreshToken});

    //clear access and refresh token
    await _storageService.deleteSecure('access_token');
    await _storageService.deleteSecure('refresh_token');
  }

  @override
  Future<void> refreshAccess(String refreshToken) async {
    final response = await _apiService.post(
      '/token/refresh',
      data: {'refresh': refreshToken},
    );

    //simpan accessToken dan refreshToken
    final accessToken = response.data['access'];
    final newRefreshToken = response.data['refresh'];
    await _storageService.writeSecure('access_token', accessToken);
    await _storageService.writeSecure('refresh_token', newRefreshToken);
  }

  @override
  Future<void> requestPasswordReset(String email) {
    // TODO: implement requestPasswordReset
    throw UnimplementedError();
  }
}
