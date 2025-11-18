import 'package:wadul_app/features/report/domain/repository/report_repository.dart';

class UpdateReportStatus {
  final ReportRepository repository;

  UpdateReportStatus(this.repository);

  Future<void> call({
    required String reportId,
    required String status,
    String? catatan,
  }) async {
    if (reportId.isEmpty) {
      throw Exception('ID laporan harus disediakan untuk pembaruan.');
    }
    if (status.isEmpty) {
      throw Exception('Status laporan tidak boleh kosong.');
    }

    await repository.updateReportStatus(
      reportId: reportId,
      status: status,
      catatan: catatan,
    );
  }
}
