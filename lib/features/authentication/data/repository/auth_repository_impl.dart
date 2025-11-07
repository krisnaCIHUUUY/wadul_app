import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/src/either.dart';
import 'package:wadul_app/core/error/failure.dart';
import 'package:wadul_app/features/authentication/data/datasource/auth_firebase_data_source.dart';
import 'package:wadul_app/features/authentication/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, String>> daftar({
    required String nama,
    required String nik,
    required String email,
    required String password,
  }) async {
    try {
      final result = await dataSource.daftar(
        nama: nama,
        nik: nik,
        email: email,
        password: password,
      );
      return right(result);
    } on FirebaseAuthException catch (e) {
      return left(Failure(message: e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> masuk({
    required String email,
    required String password,
  }) async {
    try {
      final result = await dataSource.masuk(email: email, password: password);
      return right(result);
    } on FirebaseAuthException catch (e) {
      return left(Failure(message: e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> logout() async {
    // TODO: implement logout
    try {
      await dataSource.logout();
      return right("berhasil logout");
    } on FirebaseAuthException catch (e) {
      return left(Failure(message: e.message ?? 'terjadi kesalahan'));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resetEmailPassword(String newPassword) async {
    try {

      await dataSource.resetEmailPassword(newPassword);

      return right("Password Anda telah berhasil diperbarui.");
    } on FirebaseAuthException catch (e) {

      return left(Failure(message: e.message ?? 'Gagal memperbarui password.'));
    } catch (e) {

      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> sendEmailPasswordReset({
    required String email,
  }) async {
    try {

      await dataSource.sendEmailPasswordReset(email: email);

      return right(
        "Email reset password telah dikirim ke email anda. Silakan cek email anda.",
      );
    } on FirebaseAuthException catch (e) {

      return left(Failure(message: e.message ?? 'Gagal mengirim email reset.'));
    } catch (e) {

      return left(Failure(message: e.toString()));
    }
  }
}
