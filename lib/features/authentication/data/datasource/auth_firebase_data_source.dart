import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthFirebaseDataSource {
  Future<String> daftar({
    required String nama,
    required String nik,
    required String email,
    required String password,
  });

  Future<String> masuk({required String email, required String password});
  Future<void> logout();
  Future<void> resetEmailPassword(String newPassword);
  Future<String> sendEmailPasswordReset({required String email});
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
  Future<String> daftar({
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
      final user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        await _firebaseFirestore.collection('users').doc(user.uid).set({
          'nama': nama,
          'nik': nik,
          'email': email,
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'emailVerified': user.emailVerified,
        });
        return 'berhasil mendaftar. Silakan cek email Anda untuk verifikasi.';
      } else {
        return "gagal mendaftar";
      }
    } on FirebaseAuthException catch (e) {
      return "Error Autentikasi: ${e.message}";
    } on FirebaseException catch (e) {
      return "Error Firestore: ${e.message}";
    } catch (e) {
      return "Terjadi kesalahan: ${e.toString()}";
    }
  }

  @override
  Future<String> masuk({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'Login gagal: pengguna tidak ditemukan.',
        );
      }

      if (!user.emailVerified) {
        await _firebaseAuth.signOut();
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Email Anda belum diverifikasi. Silakan cek email Anda.',
        );
      }

      return "Login berhasil";
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
}
