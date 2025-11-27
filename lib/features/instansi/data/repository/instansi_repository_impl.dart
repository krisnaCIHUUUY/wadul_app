import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wadul_app/features/instansi/data/model/instansi_model.dart';
import 'package:wadul_app/features/instansi/domain/entities/instansi_entity.dart';
import 'package:wadul_app/features/instansi/domain/repository/instansi_repository.dart';

class InstansiRepositoryImpl implements InstansiRepository {
  final FirebaseFirestore firestore;
  const InstansiRepositoryImpl({required this.firestore});

  @override
  Future<List<InstansiEntity>> fetchAllInstansi() async {
    try {
      final snapshot = await firestore.collection('instansi').get();

      final instansiList = snapshot.docs.map((doc) {
        return InstansiModel.fromMap(doc.data(), doc.id);
      }).toList();
      print(instansiList);
      return instansiList;
    } on FirebaseException catch (e) {
      // Tangani error spesifik Firebase
      print('Firebase Error fetching instansi: $e');
      throw Exception('Gagal mengambil data instansi dari server: ${e.code}');
    } catch (e) {
      // Tangani error umum
      print('Error fetching instansi: $e');
      throw Exception('Terjadi kesalahan tidak terduga.');
    }
  }
}
