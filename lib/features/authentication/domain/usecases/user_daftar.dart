import 'package:fpdart/fpdart.dart';
import 'package:wadul_app/core/error/failure.dart';
import 'package:wadul_app/features/authentication/domain/entities/user_entity.dart';
import 'package:wadul_app/features/authentication/domain/repository/auth_repository.dart';

class UserDaftar {
  final AuthRepository authRepository;
  const UserDaftar(this.authRepository);

  Future<Either<Failure, UserEntity>> call({
    required String nama,
    required String nik,
    required String email,
    required String password,
  }) async {
    return await authRepository.daftar(
      nama: nama,
      nik: nik,
      email: email,
      password: password,
    );
  }
}
