import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wadul_app/features/super_admin/data/model/users_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collectionName = 'users';

  Stream<List<UsersModel>> getUsers() {
    return _db
        .collection(collectionName)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UsersModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> createUserAdmin({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final newAdminId = userCredential.user!.uid;

      final userData = {
        'email': email,
        'password': password,
        "role": role,
        "isAdmin": true,
        'adminUid': newAdminId,
      };

      await _db.collection(collectionName).doc(newAdminId).set(userData);

      // Log success (opsional)
      log('Akun Admin berhasil ditambahkan dengan UID: $newAdminId');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Password yang diberikan terlalu lemah.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Akun sudah ada untuk email tersebut.');
      }
      // Lempar kembali error lain
      log(e.message.toString());
      throw Exception('Gagal membuat akun Admin: ${e.message}');
    } catch (e) {
      throw Exception(
        'Terjadi kesalahan tidak terduga saat menambahkan Admin: $e',
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('Pengguna berhasil logout.');
    } catch (e) {
      // Menangkap error jika proses sign out gagal (walaupun jarang terjadi)
      throw Exception('Gagal Logout: $e');
    }
  }

  
}

