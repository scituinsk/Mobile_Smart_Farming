import 'package:pak_tani/src/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<void> execute({
    required String firstName,
    String? lastName,
    required String username,
    required String email,
    required String password1,
    required String password2,
  }) async {
    _validateRegistrationData(firstName, username, email, password1, password2);

    await _repository.register(
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      password1: password1,
      password2: password2,
    );
  }

  void _validateRegistrationData(
    String firstName,
    String username,
    String email,
    String password1,
    String password2,
  ) {
    if (firstName.isEmpty) throw Exception('Nama tidak boleh kosong');
    if (username.isEmpty) throw Exception('Username tidak boleh kosong');
    if (email.isEmpty) throw Exception('Email tidak boleh kosong');
    if (password1.isEmpty) throw Exception('Password tidak boleh kosong');
    if (password1 != password2) throw Exception('Password tidak cocok');
    if (password1.length < 6) throw Exception('Password minimal 6 karakter');
  }
}
