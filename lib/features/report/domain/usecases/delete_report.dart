import 'package:wadul_app/features/report/domain/repository/report_repository.dart';

class DeleteReport {
  final ReportRepository repository;

  DeleteReport(this.repository);

  Future<void> call(String reportId) async {
    if (reportId.isEmpty) {
      throw Exception('ID laporan harus disediakan untuk dihapus.');
    }

    await repository.deleteReport(reportId);
  }
}
