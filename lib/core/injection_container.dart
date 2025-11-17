import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import 'package:wadul_app/features/report/data/datasource/report_data_source.dart';
import 'package:wadul_app/features/report/domain/repository/report_repository.dart';
import 'package:wadul_app/features/report/domain/usecases/create_report.dart';

// --- Import Use Cases yang Hilang ---
// Anda harus memastikan file-file Use Case ini di-import:
import 'package:wadul_app/features/report/domain/usecases/get_report_by_user.dart';
import 'package:wadul_app/features/report/domain/usecases/delete_report.dart';
import 'package:wadul_app/features/report/domain/usecases/update_report_status.dart';
import 'package:wadul_app/features/report/domain/usecases/get_report_by_id.dart';
// --- End Import ---

import 'package:wadul_app/features/report/data/repository/repository_impl.dart';
// import 'package:wadul_app/features/report/data/datasource/report_data_source.dart'; // Asumsi ReportDataSourceImpl ada di sini
import 'package:wadul_app/features/report/presentation/cubit/report_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // --- 1. Core/External Dependencies ---
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // --- 2. Data Layer ---
  sl.registerLazySingleton<ReportDataSource>(
    // Pastikan ini menggunakan nama implementasi class Anda
    () => ReportDataSourceImpl(sl()),
  );

  // --- 3. Domain Layer (Repository) ---
  sl.registerLazySingleton<ReportRepository>(() => RepositoryImpl(sl()));

  // --------------------------------------------------------------------------------
  // 4. Domain Layer (Use Cases) - HARUS MEREGISTRASI SEMUA DEPENDENSI CUBIT
  // --------------------------------------------------------------------------------
  sl.registerLazySingleton(() => CreateReport(sl()));

  // REGISTRASI USE CASE YANG DIBUTUHKAN CUBIT TAPI TIDAK ADA DI KODE ANDA SEBELUMNYA:
  sl.registerLazySingleton(() => GetReportsByUser(sl())); // <-- Ditambahkan
  sl.registerLazySingleton(() => DeleteReport(sl())); // <-- Ditambahkan
  sl.registerLazySingleton(() => UpdateReportStatus(sl())); // <-- Ditambahkan
  sl.registerLazySingleton(() => GetReportById(sl())); // <-- Ditambahkan

  // --------------------------------------------------------------------------------
  // 5. Presentation Layer (BLoC/Cubit) - Sekarang semua dependensi sudah ada
  // --------------------------------------------------------------------------------
  sl.registerFactory(
    () => ReportCubit(
      createNewReport: sl(),
      getReportsByUser: sl(),
      deleteReport: sl(),
      updateReportStatus: sl(),
      getReportById: sl(),
    ),
  );
}
