import 'package:fpdart/fpdart.dart';
import 'package:wadul_app/core/error/failure.dart';
import 'package:wadul_app/features/authentication/domain/repository/auth_repository.dart';

class UserLogout {
  final AuthRepository authRepository;
  const UserLogout(this.authRepository);

  Future<Either<Failure, String>> call() async {
    return await authRepository.logout();
  }

}

