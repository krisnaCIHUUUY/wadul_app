import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wadul_app/features/super_admin/data/model/report_category_data.dart';
import 'package:wadul_app/features/super_admin/data/model/report_status_data.dart';
import 'package:wadul_app/features/super_admin/data/model/report_time_data.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _collectionName = 'reports';

  Future<int> getTotalReportsCount() async {
    try {
      final CollectionReference reportsCollection = _firestore.collection(
        _collectionName,
      );

      final QuerySnapshot snapshot = await reportsCollection.get();

      return snapshot.size;
    } on FirebaseException catch (e) {
      log("Firebase Error fetching report count: $e");

      return 0;
    } catch (e) {
      log("General Error fetching report count: $e");
      return 0;
    }
  }

  Future<ReportStatusData> getReportStatusCounts() async {
    final reportsCollection = _firestore.collection(_collectionName);

    try {
      final Future<QuerySnapshot> verifyingFuture = reportsCollection
          .where('status', isEqualTo: 'Menverifikasi')
          .get();

      final Future<QuerySnapshot> inProgressFuture = reportsCollection
          .where('status', isEqualTo: 'in_progress')
          .get();

      final Future<QuerySnapshot> approvedFuture = reportsCollection
          .where('status', isEqualTo: 'disetujui')
          .get();

      final Future<QuerySnapshot> rejectedFuture = reportsCollection
          .where('status', isEqualTo: 'ditolak')
          .get();

      final List<QuerySnapshot> snapshots = await Future.wait([
        verifyingFuture,
        inProgressFuture,
        approvedFuture,
        rejectedFuture,
      ]);

      final int verifyingCount = snapshots[0].size;
      final int inProgressCount = snapshots[1].size;
      final int approvedCount = snapshots[2].size;
      final int rejectedCount = snapshots[3].size;

      return ReportStatusData(
        verifying: verifyingCount,
        inProgress: inProgressCount,
        approved: approvedCount,
        rejected: rejectedCount,
      );
    } on FirebaseException catch (e) {
      log("Firebase Error fetching report statuses: $e");
      return ReportStatusData(
        verifying: 0,
        inProgress: 0,
        approved: 0,
        rejected: 0,
      );
    } catch (e) {
      log("General Error fetching report statuses: $e");
      return ReportStatusData(
        verifying: 0,
        inProgress: 0,
        approved: 0,
        rejected: 0,
      );
    }
  }

  Future<ReportCategoryData> getReportCategoryCounts() async {
    final reportsCollection = _firestore.collection(_collectionName);

    try {
      final QuerySnapshot snapshot = await reportsCollection.get();

      final Map<String, int> categoryCounts = {};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        final String category =
            data['kategori'] as String? ?? 'Tidak Diketahui';

        categoryCounts.update(
          category,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }

      return ReportCategoryData(counts: categoryCounts);
    } on FirebaseException catch (e) {
      log("Firebase Error fetching report categories: $e");
      return ReportCategoryData(counts: {});
    } catch (e) {
      log("General Error fetching report categories: $e");
      return ReportCategoryData(counts: {});
    }
  }

  Future<ReportTimeData> getReportTimeCounts({int days = 6}) async {
    final reportsCollection = _firestore.collection(_collectionName);

    final now = DateTime.now();
    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final startDate = endDate.subtract(Duration(days: days - 1));

    String normalize(DateTime d) =>
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    try {
      final snapshot = await reportsCollection
          .where(
            'tanggal',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
          )
          .where('tanggal', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      /// 1️⃣ INIT MAP TEPAT `days` HARI (TIDAK BOLEH LEBIH)
      final Map<String, TimeData> dailyCounts = {};

      for (int i = 0; i < days; i++) {
        final date = startDate.add(Duration(days: i));
        dailyCounts[normalize(date)] = const TimeData();
      }

      /// 2️⃣ HITUNG DATA
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['tanggal'] == null) continue;

        final date = (data['tanggal'] as Timestamp).toDate();
        final key = normalize(date);

        // safety: ignore jika di luar range init
        if (!dailyCounts.containsKey(key)) continue;

        final hour = date.hour;
        final current = dailyCounts[key]!;

        if (hour >= 6 && hour < 12) {
          dailyCounts[key] = current.copyWith(pagi: current.pagi + 1);
        } else if (hour >= 12 && hour < 18) {
          dailyCounts[key] = current.copyWith(siang: current.siang + 1);
        } else {
          dailyCounts[key] = current.copyWith(malam: current.malam + 1);
        }
      }

      /// 3️⃣ SORT FINAL (SERVICE YANG TANGGUNG JAWAB)
      final sortedKeys = dailyCounts.keys.toList()..sort();

      final Map<String, TimeData> sortedMap = {
        for (final key in sortedKeys) key: dailyCounts[key]!,
      };

      return ReportTimeData(dailyCounts: sortedMap);
    } catch (e) {
      log('Error fetching report time counts: $e');
      return ReportTimeData(dailyCounts: {});
    }
  }


}
