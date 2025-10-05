import 'package:pak_tani/src/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  //auth
  Future<User> login(String email, String password);

  Future<User> register({
    required String firstName,
    String? lastName,
    required String username,
    required String email,
    required String password1,
    required String password2,
  });

  Future<void> logout();

  Future<bool> isLoggedin();

  //user management
  Future<void> requestPasswordReset(String email);
}
