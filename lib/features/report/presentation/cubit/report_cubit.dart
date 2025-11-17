// lib/features/report/presentation/cubit/report_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wadul_app/features/report/domain/entities/report_entity.dart';
import 'package:wadul_app/features/report/domain/usecases/create_report.dart';
import 'package:wadul_app/features/report/domain/usecases/delete_report.dart';
import 'package:wadul_app/features/report/domain/usecases/get_report_by_id.dart';
import 'package:wadul_app/features/report/domain/usecases/get_report_by_user.dart';
import 'package:wadul_app/features/report/domain/usecases/update_report_status.dart';
import 'package:wadul_app/features/report/presentation/cubit/report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  // Use Case yang diinject
  final CreateReport createNewReport;
  final GetReportsByUser getReportsByUser;
  final UpdateReportStatus updateReportStatus; // <-- Use Case baru
  final DeleteReport deleteReport;
  final GetReportById getReportById;

  // Daftarkan Use Case lain di sini jika dibutuhkan
  // final GetReportsByUser getReportsByUser;

  ReportCubit({
    required this.getReportById,
    required this.updateReportStatus,
    required this.deleteReport,
    required this.createNewReport,
    required this.getReportsByUser,
  }) : super(ReportInitial());

  /// Metode untuk memicu pembuatan laporan baru.
  Future<void> createReport(ReportEntity report) async {
    // 1. Emit Loading State
    emit(ReportLoading());

    try {
      // 2. Panggil Use Case
      await createNewReport(report);

      // 3. Emit Success State
      emit(const ReportSuccess("Laporan berhasil dibuat!"));
    } catch (e) {
      // 4. Tangani Error dan Emit Failure State
      // Kita ambil pesan error dari exception yang dilempar oleh Use Case/Repository
      emit(ReportFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // TODO: Tambahkan metode lain seperti updateReportStatus, deleteReport, dll.
  Future<void> fetchReportsByUser(String userId) async {
    // Emit Loading (agar UI menampilkan indikator)
    emit(ReportLoading());

    try {
      // Panggil Use Case
      final reports = await getReportsByUser(userId);

      // Emit Loaded State dengan data yang diambil
      emit(ReportLoaded(reports));
    } catch (e) {
      // Tangani Error
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
      // Panggil Use Case
      final report = await getReportById(reportId);

      // Emit State Detail Loaded
      emit(ReportDetailLoaded(report));
    } catch (e) {
      // Tangani Error
      emit(ReportFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
