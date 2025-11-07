import 'package:fpdart/fpdart.dart';
import 'package:wadul_app/core/error/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> daftar({
    required String nama,
    required String nik,
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> masuk({
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> logout();
  Future<Either<Failure, String>> resetEmailPassword(String newPassword);
  Future<Either<Failure, String>> sendEmailPasswordReset({required String email});
}
