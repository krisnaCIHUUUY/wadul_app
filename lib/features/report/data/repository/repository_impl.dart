import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wadul_app/features/report/data/datasource/report_data_source.dart';
import 'package:wadul_app/features/report/domain/entities/report_entity.dart';
import 'package:wadul_app/features/report/domain/repository/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportDataSource dataSource;
  ReportRepositoryImpl(this.dataSource);
  @override
  Future<void> addDocumentation({
    required String reportId,
    required String fotoUrl,
    required String deskripsi,
  }) async {
    try {
      await dataSource.addDocumentation(
        reportId: reportId,
        fotoUrl: fotoUrl,
        deskripsi: deskripsi,
      );
    } on FirebaseException catch (e) {
      log("Firebase error : ${e.message}", name: "RepositoryImpl");
      throw Exception("gagal menambahkan dokumentasi: ${e.message}");
    } catch (e) {
      log("unknow error : $e", name: "RepositoryImpl");
      throw Exception("terjadi kesalahan saat menambahkan dokumentasi");
    }
  }

  @override
  Future<void> createReport(ReportEntity report) async {
    try {
      await dataSource.createReport(report);
    } on FirebaseException catch (e) {
      log("firebase error: ${e.message}", name: "RepositoryImpl");
      throw Exception("gagal membuat report: ${e.message}");
    } catch (e) {
      log("unknow error: $e", name: "RepositoryImpl");
      throw Exception("terjadi kesalahan saat membuat report");
    }
  }

  @override
  Future<void> deleteReport(String reportId) {
    // TODO: implement deleteReport
    throw UnimplementedError();
  }

  @override
  Future<List<ReportEntity>> getAllReports() async {
    try {
      return await dataSource.getAllReports();
    } on FirebaseException catch (e) {
      log("firebase error: ${e.message}", name: "RepositoryImpl");
      throw Exception("gagal mengambil report: ${e.message}");
    } catch (e) {
      log("unknow error: $e", name: "RepositoryImpl");
      throw Exception("terjadi kesalahan saat mengambil data");
    }
  }

  @override
  Future<ReportEntity> getReportById(String reportId) async {
    try {
      return await dataSource.getReportById(reportId);
    } on FirebaseException catch (e) {
      log("firebase error: ${e.message}", name: "RepositoryImpl");
      throw Exception("gagal mengambil data report user by id: ${e.message}");
    } catch (e) {
      log("unknow error: $e", name: "RepositoryImpl");
      throw Exception(
        "terjadi kesalahan saat mengambil data report user by id",
      );
    }
  }

  @override
  Future<List<ReportEntity>> getReportsByUser(String userId) async {
    try {
      return await dataSource.getReportByUser(userId);
    } on FirebaseException catch (e) {
      log("firebase error: ${e.message}", name: "RepositoryImpl");
      throw Exception("terjadi kesalahan saat mengambil data report user");
    } catch (e) {
      log("unknow error: $e", name: "RepositoryImpl");
      throw Exception("terjadi kesalahan saat mengambil data report user");
    }
  }

  @override
  Future<void> updateReportStatus({
    required String reportId,
    required String status,
    String? catatan,
  }) {
    // TODO: implement updateReportStatus
    throw UnimplementedError();
  }
}
