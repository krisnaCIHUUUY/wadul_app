// lib/features/report/domain/usecases/get_reports_by_user.dart

import 'package:wadul_app/features/report/domain/entities/report_entity.dart';
import 'package:wadul_app/features/report/domain/repository/report_repository.dart';

class GetReportsByUser {
  final ReportRepository repository;

  GetReportsByUser(this.repository);

  /// Mengambil daftar laporan berdasarkan ID pengguna tertentu.
  /// Menerima [userId] sebagai parameter.
  Future<List<ReportEntity>> call(String userId) async {
    // 1. Logika Bisnis (misalnya, memvalidasi format userId)
    if (userId.isEmpty) {
      throw Exception('User ID tidak boleh kosong.');
    }

    // 2. Memanggil Repository untuk mendapatkan data
    return await repository.getReportsByUser(userId);
  }
}
