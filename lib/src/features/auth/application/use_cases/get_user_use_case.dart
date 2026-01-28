import 'package:pak_tani/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:pak_tani/src/features/profile/domain/entities/user.dart';

class GetUserUseCase {
  final AuthRepository _repository;

  GetUserUseCase(this._repository);

  Future<User?> execute() async {
    return await _repository.getCurrentUser();
  }
}
