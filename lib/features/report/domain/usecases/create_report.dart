import 'package:wadul_app/features/report/domain/entities/report_entity.dart';
import 'package:wadul_app/features/report/domain/repository/report_repository.dart';

class CreateReport {
  final ReportRepository repository;
  CreateReport(this.repository);

  Future<void> call(ReportEntity report) async {
    if (report.judul.isEmpty || report.deskripsi.isEmpty) {
      throw Exception("judul dan deskripsi tidak boleh kosong");
    }
    await repository.createReport(report);
  }
}
