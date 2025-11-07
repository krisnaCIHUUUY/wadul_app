import 'package:fpdart/fpdart.dart';
import 'package:wadul_app/core/error/failure.dart';
import 'package:wadul_app/features/authentication/domain/repository/auth_repository.dart';

class UserUpdateSandi {
  final AuthRepository authRepository;

  UserUpdateSandi(this.authRepository);

  Future<Either<Failure, String>> call(String password) async {
    return await authRepository.resetEmailPassword(password);
  }
}
