import 'package:get/get.dart';
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';
import 'package:pak_tani/src/features/auth/data/models/user_model.dart';
import 'package:pak_tani/src/features/auth/domain/datasources/auth_remote_datasource.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await _apiService.post(
      '/login',
      data: {'username': email, 'password': password},
    );

    final responseData = response.data['data'] as Map<String, dynamic>;

    //simpan accessToken dan refreshToken
    final accessToken = responseData['access'];
    final refreshToken = responseData['refresh'];
    await _storageService.writeSecure('access_token', accessToken);
    await _storageService.writeSecure('refresh_token', refreshToken);

    return UserModel.fromJson(responseData['user']);
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
    final requestData = <String, dynamic>{
      'first_name': firstName,
      'username': username,
      'email': email,
      'password1': password1,
      'password2': password2,
    };

    // Only add last_name if it's not null
    if (lastName != null && lastName.isNotEmpty) {
      requestData['last_name'] = lastName;
    }

    print('Register Request Data: $requestData');

    await _apiService.post('/register', data: requestData);

    print("register sampai sini le");
  }

  @override
  Future<void> logout(String refreshToken) async {
    await _apiService.post('/logout', data: {'refresh': refreshToken});

    //clear access and refresh token
    await _storageService.deleteSecure('access_token');
    await _storageService.deleteSecure('refresh_token');
  }

  @override
  Future<Map<String, String>> refreshAccess(String refreshToken) async {
    final response = await _apiService.post(
      '/token/refresh',
      data: {'refresh': refreshToken},
    );

    //simpan accessToken dan refreshToken
    final accessToken = response.data['access'];
    final newRefreshToken = response.data['refresh'];
    await _storageService.writeSecure('access_token', accessToken);
    await _storageService.writeSecure('refresh_token', newRefreshToken);

    return {'access': accessToken, 'refresh': newRefreshToken};
  }

  @override
  Future<void> requestPasswordReset(String email) {
    // TODO: implement requestPasswordReset
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final response = await _apiService.get('/user/me');

    final responseData = response.data['data'] as Map<String, dynamic>;

    return UserModel.fromJson(responseData);
  }
}
