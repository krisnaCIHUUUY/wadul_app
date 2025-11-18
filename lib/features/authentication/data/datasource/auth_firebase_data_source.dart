import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wadul_app/features/authentication/data/models/user_model.dart';
import 'package:wadul_app/features/authentication/domain/entities/user_entity.dart';

abstract interface class AuthFirebaseDataSource {
  Future<UserEntity> daftar({
    required String nama,
    required String nik,
    required String email,
    required String password,
  });

  Future<UserEntity> masuk({required String email, required String password});
  Future<void> logout();
  Future<void> resetEmailPassword(String newPassword);
  Future<String> sendEmailPasswordReset({required String email});
  Future<UserEntity?> getCurrentUser();
}

class AuthFirebaseDataSourceImpl implements AuthFirebaseDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  AuthFirebaseDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseAuth = firebaseAuth,
       _firebaseFirestore = firebaseFirestore;

  @override
  Future<UserEntity> daftar({
    required String nama,
    required String nik,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        await firebaseUser.sendEmailVerification();
        final userModel = UserModel.fromFirebaseUser(firebaseUser);

        await _firebaseFirestore.collection('users').doc(firebaseUser.uid).set({
          'nama': nama,
          'nik': nik,
          'email': email,
          'uid': firebaseUser.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'emailVerified': firebaseUser.emailVerified,
        });
        return userModel;
      }
      throw FirebaseAuthException(
        code: 'sign-up-failed',
        message: 'Gagal memdaftar',
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } on FirebaseException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      throw Exception('terjadi kesalahan: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> masuk({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'Login gagal: pengguna tidak ditemukan.',
        );
      }

      if (!firebaseUser.emailVerified) {
        await _firebaseAuth.signOut();
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Email Anda belum diverifikasi. Silakan cek email Anda.',
        );
      }

      final userModel = UserModel.fromFirebaseUser(firebaseUser);

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'Gagal login. Silakan coba lagi.',
      );
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unexpected-error',
        message: 'Kesalahan tidak terduga: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> resetEmailPassword(String newPassword) async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await _firebaseAuth.currentUser?.updatePassword(newPassword);
    } else {
      throw FirebaseAuthException(
        code: "user-not-found",
        message:
            "email yang anda masukkan belum terdaftar. silahkan masukkan email yang valid",
      );
    }
  }

  @override
  Future<String> sendEmailPasswordReset({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "email untuk reset password telah di kirimkan, silahkan cek email anda.";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Email yang Anda masukkan tidak terdaftar.';
      } else if (e.code == 'invalid-email') {
        return 'Format email tidak valid.';
      }
      return 'Gagal mengirim email: ${e.message}';
    } catch (e) {
      return 'Terjadi kesalahan: ${e.toString()}';
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      return UserModel.fromFirebaseUser(firebaseUser);
    }
    return null;
  }
}
