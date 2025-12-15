// File: lib/models/report_category_data.dart

class ReportCategoryData {
  // Kita akan menggunakan Map<String, int> untuk menampung hasil
  // { 'Fasilitas Umum': 13, 'Kerusakan': 7, 'Layanan': 8, ... }
  final Map<String, int> counts;
  final int total;

  ReportCategoryData({required this.counts})
    : total = counts.values.fold(0, (sum, count) => sum + count);
}
