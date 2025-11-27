import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
// import 'package:wadul_app/core/error/failure.dart';
import 'package:wadul_app/features/report/domain/entities/report_entity.dart';
import 'package:wadul_app/features/report/presentation/cubit/report_cubit.dart';
import 'package:wadul_app/features/report/presentation/cubit/report_state.dart';
import 'package:wadul_app/features/report/presentation/widgets/laporan_tile.dart';

final sl = GetIt.instance;

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late final ReportCubit _reportCubit;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _reportCubit = sl<ReportCubit>();

    if (userId != null) {
      _reportCubit.getReportsByUser(userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReportCubit>(
      create: (context) => _reportCubit,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 30, bottom: 20),
                child: Text(
                  'Daftar Laporan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<ReportCubit, ReportState>(
                  builder: (context, state) {
                    if (state is ReportLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // 2. Error State
                    if (state is ReportFailure) {
                      return Center(
                        child: Text(
                          'Gagal memuat laporan: ${state.message}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (state is ReportLoaded) {
                      final List<ReportEntity> reportList = state.reports;

                      return ListView.builder(
                        itemCount: reportList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          final report = reportList[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: LaporanTile(
                              judul: report.judul,
                              namaIntansi: report.tanggal.toString(),
                              status: report.status,
                              statusBackground: report.status == "Pending"
                                  ? pendingBackground
                                  : diterimaBackground,
                              statusColor: report.status == "Pending"
                                  ? pendingColor
                                  : diterimaColor,
                            ),
                          );
                        },
                      );
                    }
                    return SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
