import 'package:fpdart/fpdart.dart';
import 'package:wadul_app/core/error/failure.dart';
import 'package:wadul_app/features/authentication/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> daftar({
    required String nama,
    required String nik,
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> masuk({
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> logout();
  Future<Either<Failure, String>> resetEmailPassword(String newPassword);
  Future<Either<Failure, String>> sendEmailPasswordReset({
    required String email,
  });
  Future<Either<Failure, UserEntity?>> getCurrentUser();
}
