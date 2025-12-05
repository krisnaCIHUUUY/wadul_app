

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wadul_app/features/report/domain/entities/report_entity.dart';
import 'package:wadul_app/features/report/domain/usecases/create_report.dart';
import 'package:wadul_app/features/report/domain/usecases/delete_report.dart';
import 'package:wadul_app/features/report/domain/usecases/get_report_by_id.dart';
import 'package:wadul_app/features/report/domain/usecases/get_report_by_user.dart';
import 'package:wadul_app/features/report/domain/usecases/update_report_status.dart';
import 'package:wadul_app/features/report/presentation/cubit/report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final CreateReport createNewReport;
  final GetReportsByUser getReportsByUser;
  final UpdateReportStatus updateReportStatus; 
  final DeleteReport deleteReport;
  final GetReportById getReportById;

  ReportCubit({
    required this.getReportById,
    required this.updateReportStatus,
    required this.deleteReport,
    required this.createNewReport,
    required this.getReportsByUser,
  }) : super(ReportInitial());

  Future<void> createReport(ReportEntity report) async {
    emit(ReportLoading());

    try {
      await createNewReport(report);
      emit(const ReportSuccess("Laporan berhasil dibuat!"));
    } catch (e) {

      emit(ReportFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> fetchReportsByUser(String userId) async {
    emit(ReportLoading());

    try {
      final reports = await getReportsByUser(userId);

      emit(ReportLoaded(reports));
    } catch (e) {
      emit(ReportFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> updateStatus({
    required String reportId,
    required String status,
    String? catatan,
  }) async {
    emit(ReportLoading());
    try {
      await updateReportStatus(
        reportId: reportId,
        status: status,
        catatan: catatan,
      );

      // Setelah berhasil, Anda mungkin ingin memuat ulang daftar laporan pengguna
      // emit(const ReportSuccess("Status laporan berhasil diperbarui!"));
      // Atau, jika Anda tahu userId-nya, Anda bisa memanggil:
      // await fetchReportsByUser(currentUserId);

      emit(const ReportSuccess("Status laporan berhasil diperbarui!"));
    } catch (e) {
      emit(ReportFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> delete(String reportId) async {
    emit(ReportLoading());
    try {
      await deleteReport(reportId);

      // Setelah berhasil, Anda mungkin ingin memuat ulang daftar laporan pengguna
      // await fetchReportsByUser(currentUserId);

      emit(const ReportSuccess("Laporan berhasil dihapus!"));
    } catch (e) {
      emit(ReportFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> fetchReportById(String reportId) async {
    emit(ReportLoading());

    try {
      final report = await getReportById(reportId);

      emit(ReportDetailLoaded(report));
    } catch (e) {
      emit(ReportFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
