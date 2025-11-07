import 'package:fpdart/fpdart.dart';
import 'package:wadul_app/core/error/failure.dart';
import 'package:wadul_app/features/authentication/domain/repository/auth_repository.dart';

class UserLupaSandi {
  final AuthRepository authRepository;
  UserLupaSandi(this.authRepository);

  Future<Either<Failure, String>> call(String email) async {
    return await authRepository.sendEmailPasswordReset(email: email);
  }
}
