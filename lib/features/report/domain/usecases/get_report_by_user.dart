// lib/features/report/domain/usecases/get_reports_by_user.dart

import 'package:wadul_app/features/report/domain/entities/report_entity.dart';
import 'package:wadul_app/features/report/domain/repository/report_repository.dart';

class GetReportsByUser {
  final ReportRepository repository;

  GetReportsByUser(this.repository);


  Future<List<ReportEntity>> call(String userId) async {
    if (userId.isEmpty) {
      throw Exception('User ID tidak boleh kosong.');
    }

    return await repository.getReportsByUser(userId);
  }
}
