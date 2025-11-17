import 'package:wadul_app/features/report/domain/repository/report_repository.dart';

class UpdateReportStatus {
  final ReportRepository repository;

  UpdateReportStatus(this.repository);

  /// Memperbarui status laporan tertentu.
  Future<void> call({
    required String reportId,
    required String status,
    String? catatan,
  }) async {
    // 1. Logika Bisnis (Validasi)
    if (reportId.isEmpty) {
      throw Exception('ID laporan harus disediakan untuk pembaruan.');
    }
    if (status.isEmpty) {
      throw Exception('Status laporan tidak boleh kosong.');
    }

    // 2. Memanggil Repository
    await repository.updateReportStatus(
      reportId: reportId,
      status: status,
      catatan: catatan,
    );
  }
}
