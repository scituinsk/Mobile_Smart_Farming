import 'package:pak_tani/src/features/auth/domain/entities/user.dart';
import 'package:pak_tani/src/features/auth/domain/repositories/auth_repository.dart';

class GetUserUseCase {
  final AuthRepository _repository;

  GetUserUseCase(this._repository);

  Future<User?> execute() async {
    return await _repository.getCurrentUser();
  }
}
