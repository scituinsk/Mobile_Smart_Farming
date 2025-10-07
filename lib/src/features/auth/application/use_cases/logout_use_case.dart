import 'package:pak_tani/src/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<void> execute() async {
    try {
      await _repository.logout();
    } catch (e) {
      print('logout usecase error (tetep lanjut): $e');
    }
  }
}
