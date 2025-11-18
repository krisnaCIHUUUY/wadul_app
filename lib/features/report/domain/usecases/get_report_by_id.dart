import 'package:wadul_app/features/report/domain/entities/report_entity.dart';
import 'package:wadul_app/features/report/domain/repository/report_repository.dart';

class GetReportById {
  final ReportRepository repository;

  GetReportById(this.repository);

  Future<ReportEntity> call(String reportId) async {
    if (reportId.isEmpty) {
      throw Exception('Report ID tidak boleh kosong.');
    }
    return await repository.getReportById(reportId);
  }
}
