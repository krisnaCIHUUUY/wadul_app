import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:wadul_app/features/instansi/data/repository/instansi_repository_impl.dart';
import 'package:wadul_app/features/instansi/domain/repository/instansi_repository.dart';
import 'package:wadul_app/features/instansi/presentation/cubit/instansi_cubit.dart';

import 'package:wadul_app/features/report/data/datasource/report_data_source.dart';
import 'package:wadul_app/features/report/domain/repository/report_repository.dart';
import 'package:wadul_app/features/report/domain/usecases/create_report.dart';

import 'package:wadul_app/features/report/domain/usecases/get_report_by_user.dart';
import 'package:wadul_app/features/report/domain/usecases/delete_report.dart';
import 'package:wadul_app/features/report/domain/usecases/update_report_status.dart';
import 'package:wadul_app/features/report/domain/usecases/get_report_by_id.dart';
import 'package:wadul_app/features/report/data/repository/repository_impl.dart';
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
  sl.registerLazySingleton<ReportRepository>(() => ReportRepositoryImpl(sl()));

  // --------------------------------------------------------------------------------
  // 4. Domain Layer (Use Cases) - HARUS MEREGISTRASI SEMUA DEPENDENSI CUBIT
  // --------------------------------------------------------------------------------
  sl.registerLazySingleton(() => CreateReport(sl()));

  // REGISTRASI USE CASE YANG DIBUTUHKAN CUBIT TAPI TIDAK ADA DI KODE ANDA SEBELUMNYA:
  sl.registerLazySingleton(() => GetReportsByUser(sl()));
  sl.registerLazySingleton(() => DeleteReport(sl()));
  sl.registerLazySingleton(() => UpdateReportStatus(sl()));
  sl.registerLazySingleton(() => GetReportById(sl()));
  // sl.registerLazySingleton(() => GetCurrentUser(sl()));

  sl.registerLazySingleton<InstansiRepository>(
    () => InstansiRepositoryImpl(firestore: sl()),
  );

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

  sl.registerFactory(() => InstansiCubit(repository: sl()));
}
