// lib/features/report/domain/usecases/get_report_by_id.dart

import 'package:wadul_app/features/report/domain/entities/report_entity.dart';
import 'package:wadul_app/features/report/domain/repository/report_repository.dart';

class GetReportById {
  final ReportRepository repository;

  GetReportById(this.repository);

  /// Mengambil satu laporan berdasarkan ID laporan.
  /// Menerima [reportId] sebagai parameter.
  Future<ReportEntity> call(String reportId) async {
    // 1. Logika Bisnis (Validasi)
    if (reportId.isEmpty) {
      throw Exception('Report ID tidak boleh kosong.');
    }

    // 2. Memanggil Repository untuk mendapatkan data
    return await repository.getReportById(reportId);
  }
}
