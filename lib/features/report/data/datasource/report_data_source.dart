import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wadul_app/features/report/data/model/report_model.dart';
import 'package:wadul_app/features/report/domain/entities/report_entity.dart';

abstract class ReportDataSource {
  Future<void> createReport(ReportEntity report);
  Future<List<ReportEntity>> getReportByUser(String userId);
  Future<ReportEntity> getReportById(String reportId);
  Future<void> updateReportStatus({
    required String reportId,
    required String status,
    String? catatan,
  });

  Future<void> addDocumentation({
    required String reportId,
    required String fotoUrl,
    required String deskripsi,
  });

  Future<List<ReportEntity>> getAllReports();

  Future<void> deleteReport(String reportId);
}

class ReportDataSourceImpl implements ReportDataSource {
  final FirebaseFirestore _firebaseFirestore;
  ReportDataSourceImpl(this._firebaseFirestore);

  @override
  Future<void> addDocumentation({
    required String reportId,
    required String fotoUrl,
    required String deskripsi,
  }) async {
    try {
      final newDocumentationMap = {
        "fotoUrl": fotoUrl,
        "deskripsi": deskripsi,
        "createAt": FieldValue.serverTimestamp(),
      };

      await _firebaseFirestore.collection("reports").doc(reportId).update({
        'documentation': FieldValue.arrayUnion([newDocumentationMap]),
      });
    } on FirebaseException catch (e) {
      log("firebase error di didoucmentation ${e.message}");
      throw Exception("gagal saat membuat documentation ${e.code}");
    } catch (e) {
      log("error tak terduga : $e");
      throw Exception("terjadi kesalahan saat membuat documentasi");
    }
  }

  @override
  Future<void> createReport(ReportEntity report) async {
    try {
      final reportModel = ReportModel.fromEntity(report);
      Map<String, dynamic> dataToSave = reportModel.toMap();
      await _firebaseFirestore.collection("reports").doc().set(dataToSave);
      log("data behasil di upload");
    } on FirebaseException catch (e) {
      log("error takterduga:  ${e.message}");
      throw Exception("hterjadi kesalahan tak terduga saat membuat report");
    }
  }

  @override
  Future<void> deleteReport(String reportId) async {
    try {
      await _firebaseFirestore.collection("reports").doc(reportId).delete();
      log('laporan berhasil di hapus');
    } on FirebaseException catch (e) {
      log("firebase error : ${e.message}");
      throw Exception("gagal menghapus laporan ${e.message}");
    } catch (e) {
      log("unknow error: $e");
      throw Exception("terjadi kesalahan saat menghapus laporan: $e");
    }
  }

  @override
  Future<List<ReportEntity>> getAllReports() async {
    try {
      final QuerySnapshot snapshot = await _firebaseFirestore
          .collection("reports")
          .get();

      final List<ReportEntity> reports = snapshot.docs
          .map(
            (doc) =>
                ReportModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();

      log('Berhasil mengambil ${reports.length} laporan.');
      return reports;
    } on FirebaseException catch (e) {
      log(' Firebase Error saat getAllReports: ${e.message}');
      throw Exception('Gagal mengambil semua laporan: ${e.code}');
    } catch (e) {
      log(' Error tak terduga saat getAllReports: $e');
      throw Exception(
        'Terjadi kesalahan tidak terduga saat mengambil laporan.',
      );
    }
  }

  @override
  Future<ReportEntity> getReportById(String reportId) async {
    try {
      final DocumentSnapshot docSnapshot = await _firebaseFirestore
          .collection("reports")
          .doc(reportId)
          .get();

      if (!docSnapshot.exists) {
        throw Exception('Laporan dengan ID $reportId tidak ditemukan.');
      }

      final ReportModel report = ReportModel.fromMap(
        docSnapshot.data() as Map<String, dynamic>,
        docSnapshot.id,
      );

      log('Berhasil mengambil laporan ID: $reportId.');
      return report;
    } on FirebaseException catch (e) {
      log('Firebase Error saat getReportById: ${e.message}');
      throw Exception('Gagal mengambil laporan berdasarkan ID: ${e.code}');
    } catch (e) {
      log('Error tak terduga saat getReportById: $e');
      throw Exception(
        'Terjadi kesalahan tidak terduga saat mengambil laporan.',
      );
    }
  }

  @override
  Future<List<ReportEntity>> getReportByUser(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firebaseFirestore
          .collection("reports")
          .where('userId', isEqualTo: userId)
          .get();

      final List<ReportEntity> reports = snapshot.docs
          .map(
            (doc) =>
                ReportModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();

      log(
        'Berhasil mengambil ${reports.length} laporan untuk User ID: $userId.',
      );
      return reports;
    } on FirebaseException catch (e) {
      log('Firebase Error saat getReportByUser: ${e.message}');
      throw Exception('Gagal mengambil laporan berdasarkan user: ${e.code}');
    } catch (e) {
      log(' Error tak terduga saat getReportByUser: $e');
      throw Exception(
        'Terjadi kesalahan tidak terduga saat mengambil laporan.',
      );
    }
  }

  @override
  Future<void> updateReportStatus({
    required String reportId,
    required String status,
    String? catatan,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (catatan != null && catatan.isNotEmpty) {
        updateData['catatanAdmin'] = catatan;
      }

      await _firebaseFirestore
          .collection("reports")
          .doc(reportId)
          .update(updateData);

      log(
        'Status laporan ID: $reportId berhasil diperbarui menjadi "$status".',
      );
    } on FirebaseException catch (e) {
      log('Firebase Error saat updateReportStatus: ${e.message}');
      throw Exception('Gagal memperbarui status laporan: ${e.code}');
    } catch (e) {
      log('Error tak terduga saat updateReportStatus: $e');
      throw Exception(
        'Terjadi kesalahan tidak terduga saat memperbarui status laporan.',
      );
    }
  }
}
