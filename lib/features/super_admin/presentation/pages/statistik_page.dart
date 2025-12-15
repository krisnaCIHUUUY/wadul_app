import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/features/super_admin/data/datasource/reports_service.dart';
import 'package:wadul_app/features/super_admin/data/model/report_category_data.dart';
import 'package:wadul_app/features/super_admin/data/model/report_status_data.dart';
import 'package:wadul_app/features/super_admin/data/model/report_time_data.dart';
import 'package:wadul_app/features/super_admin/presentation/widgets/custom_activity_log_chart.dart';
import 'package:wadul_app/features/super_admin/presentation/widgets/custom_bar_chart_card.dart';
import 'package:wadul_app/features/super_admin/presentation/widgets/custom_pie_chart_card.dart';

class StatistikPage extends StatefulWidget {
  const StatistikPage({super.key});

  @override
  State<StatistikPage> createState() => _StatistikPageState();
}

class _StatistikPageState extends State<StatistikPage> {
  final ReportService _reportService = ReportService();
  int totalReports = 0;

  ReportStatusData? statusData;
  ReportCategoryData? categoryData;
  ReportTimeData? timeData;

  final List<ActivityLog> _activityLogs = [
    ActivityLog(1, 'Erica', 'Holabird', 'User'),
    ActivityLog(2, 'Marguerite', 'Labada', 'User'),
    ActivityLog(3, 'Jamie', 'Loffler', 'User'),
    ActivityLog(4, 'Melanie', 'Langewich', 'Admin'),
    ActivityLog(5, 'Loren', 'Bumbaugh', 'Admin'),
    ActivityLog(6, 'Betny', 'Punty', 'Admin'),
  ];

  @override
  void initState() {
    super.initState();
    _fetchTotalReports();
    _fetchReportStatuses();
    _fetchReportCategories();
    _fetchReportTimeCounts();
  }

  void _fetchTotalReports() async {
    final count = await _reportService.getTotalReportsCount();
    setState(() {
      totalReports = count;
    });
  }

  void _fetchReportStatuses() async {
    final data = await _reportService.getReportStatusCounts();
    setState(() {
      statusData = data;
    });
  }

  void _fetchReportCategories() async {
    final data = await _reportService.getReportCategoryCounts();
    setState(() {
      categoryData = data;
    });
  }

  void _fetchReportTimeCounts() async {
    final data = await _reportService.getReportTimeCounts(days: 12);
    setState(() {
      timeData = data;
    });
  }

  List<PieChartSectionData> _getCategoryPieData(ReportCategoryData data) {
    // ... (Logika yang sudah benar)
    const List<Color> colorPalette = [
      Colors.blueAccent,
      Colors.pinkAccent,
      Colors.red,
      Colors.purple,
      Colors.green,
    ];

    List<PieChartSectionData> sections = [];
    int colorIndex = 0;

    data.counts.forEach((categoryName, count) {
      if (count > 0) {
        sections.add(
          PieChartSectionData(
            color: colorPalette[colorIndex % colorPalette.length],
            value: count.toDouble(),
            title: count.toString(),
            radius: 40,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            badgeWidget: Text(categoryName),
          ),
        );
      }
      colorIndex++;
    });
    return sections;
  }

  List<PieChartSectionData> _getStatusPieData(ReportStatusData data) {
    // ... (Logika yang sudah benar)
    const colorVerifying = Colors.blue;
    const colorInProgress = Colors.orange;
    const colorApproved = Colors.lightGreen;
    const colorRejected = Colors.red;

    return [
      if (data.verifying > 0)
        PieChartSectionData(
          color: colorVerifying,
          value: data.verifying.toDouble(),
          title: data.verifying.toString(),
          radius: 40,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      if (data.inProgress > 0)
        PieChartSectionData(
          color: colorInProgress,
          value: data.inProgress.toDouble(),
          title: data.inProgress.toString(),
          radius: 40,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      if (data.approved > 0)
        PieChartSectionData(
          color: colorApproved,
          value: data.approved.toDouble(),
          title: data.approved.toString(),
          radius: 40,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      if (data.rejected > 0)
        PieChartSectionData(
          color: colorRejected,
          value: data.rejected.toDouble(),
          title: data.rejected.toString(),
          radius: 40,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
    ];
  }

  List<String> _getTimeLabels(ReportTimeData data) {
    final sortedDates = data.dailyCounts.keys.toList()
      ..sort(); // ISO string aman disort langsung

    return sortedDates.map((dateString) {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}";
    }).toList();
  }

  List<BarChartGroupData> _getTimeBarGroups(ReportTimeData data) {
    if (data.dailyCounts.isEmpty) return [];

    List<BarChartGroupData> groups = [];
    final double barWidth = 12.0;

    // 1. Urutkan kunci (tanggal) dari yang paling lama ke yang terbaru
    final sortedDates = data.dailyCounts.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    // 2. Tentukan indeks mulai: Ambil 6 periode terbaru
    // Jika ada 12 hari data, kita mulai dari index 6 (12 - 6 = 6)
    // final int startIndex = sortedDates.length > 6 ? sortedDates.length - 6 : 0;

    // 3. Kita hanya membuat 6 Bar Chart Group
    for (int i = 0; i < sortedDates.length; i++) {
      // Ambil tanggal dari 6 periode terakhir
      final dateKey = sortedDates[i];
      final counts = data.dailyCounts[dateKey]!; // Ambil data hitungan

      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: (counts.pagi + counts.siang + counts.malam).toDouble(),
              rodStackItems: [
                BarChartRodStackItem(
                  0,
                  counts.pagi.toDouble(),
                  Colors.deepPurple,
                ),
                BarChartRodStackItem(
                  counts.pagi.toDouble(),
                  (counts.pagi + counts.siang).toDouble(),
                  Colors.orange,
                ),
                BarChartRodStackItem(
                  (counts.pagi + counts.siang).toDouble(),
                  (counts.pagi + counts.siang + counts.malam).toDouble(),
                  Colors.red,
                ),
              ],
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan data untuk Pie Chart
    final List<PieChartSectionData> statusPieData = statusData != null
        ? _getStatusPieData(statusData!)
        : [];
    final List<PieChartSectionData> categoryPieData = categoryData != null
        ? _getCategoryPieData(categoryData!)
        : [];

    // Tentukan data untuk Bar Chart
    final List<BarChartGroupData> timeBarGroups = timeData != null
        ? _getTimeBarGroups(timeData!)
        : [];

    // Tentukan nilai maxY untuk Bar Chart
    double timeChartMaxY = 15;
    if (timeData != null && timeBarGroups.isNotEmpty) {
      final maxCount = timeBarGroups.fold<double>(0, (max, group) {
        final groupMax = group.barRods.fold<double>(
          0,
          (rodMax, rod) => rod.toY > rodMax ? rod.toY : rodMax,
        );
        return groupMax > max ? groupMax : max;
      });
      timeChartMaxY = (maxCount > 5) ? maxCount * 1.2 : 10.0;
    }

    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Center(
                child: Text(
                  "Statistik",
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: kuning,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jumlah Laporan",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Desember",
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "2025",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                      Text(
                        totalReports.toString(),
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 60,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: categoryData == null
                        ? const Center(child: CircularProgressIndicator())
                        : CustomPieChartCard(
                            title: 'Kategori',
                            data: categoryPieData,
                            type: 'Kategori',
                            fontFamily: "Poppins",
                            dynamicLabels: categoryData!.counts,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: statusData == null
                        ? const Center(child: CircularProgressIndicator())
                        : CustomPieChartCard(
                            title: 'Status',
                            data: statusPieData,
                            type: 'Status',
                            fontFamily: "Poppins",
                          ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // DIAGRAM BATANG WAKTU - MENGGUNAKAN DATA REAL-TIME
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: timeData == null
                  ? const Center(child: CircularProgressIndicator())
                  : CustomBarChartCard(
                      title: 'Waktu',
                      barGroups: timeBarGroups,
                      fontFamily: "Poppins",
                      // maxY: timeChartMaxY,
                      bottomLabels: _getTimeLabels(timeData!),
                    ),
            ),

            const SizedBox(height: 20),

            // TABEL LOG AKTIVITAS (Masih menggunakan dummy)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomActivityLogTable(
                logs: _activityLogs,
                fontFamily: "Poppins",
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
