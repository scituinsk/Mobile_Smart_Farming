import 'package:pak_tani/src/features/profile/data/models/user_model.dart';

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
  Future<Map<String, String>> refreshAccess(String refreshToken);
  Future<void> requestPasswordReset(String email);
  Future<UserModel?> getCurrentUser();
}
