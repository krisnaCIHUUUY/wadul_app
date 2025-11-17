import '../entities/report_entity.dart';

abstract class ReportRepository {
  Future<void> createReport(ReportEntity report);

  Future<List<ReportEntity>> getReportsByUser(String userId);

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
