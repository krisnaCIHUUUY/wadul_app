import 'package:wadul_app/features/report/domain/repository/report_repository.dart';

class DeleteReport {
  final ReportRepository repository;

  DeleteReport(this.repository);

  /// Menghapus laporan berdasarkan ID.
  Future<void> call(String reportId) async {
    // 1. Logika Bisnis (Validasi)
    if (reportId.isEmpty) {
      throw Exception('ID laporan harus disediakan untuk dihapus.');
    }

    // 2. Memanggil Repository
    await repository.deleteReport(reportId);
  }
}
