import 'package:fpdart/fpdart.dart';
import 'package:wadul_app/core/error/failure.dart';
import 'package:wadul_app/features/authentication/domain/entities/user_entity.dart';
import 'package:wadul_app/features/authentication/domain/repository/auth_repository.dart';

class UserMasuk {
  final AuthRepository authRepository;
  const UserMasuk(this.authRepository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await authRepository.masuk(email: email, password: password);
  }
}
