import 'package:pak_tani/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:pak_tani/src/features/profile/domain/entities/user.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<User> execute(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email dan password tidak boleh kosong');
    }

    return await _repository.login(email, password);
  }
}
