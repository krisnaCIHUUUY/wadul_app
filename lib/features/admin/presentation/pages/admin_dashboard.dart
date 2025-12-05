// lib/screens/admin_dashboard_ui.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/features/admin/presentation/pages/detail_laporan_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk simulasi daftar laporan
    final List<Map<String, dynamic>> dummyReports = [
      {
        'title': 'Di kampung saya jalan berlubang...',
        'status': 'Menunggu Verifikasi',
        'statusColor': Colors.grey,
      },
      {
        'title': 'Di kampung saya jalan berlubang...',
        'status': 'Selesai',
        'statusColor': Colors.green,
      },
      {
        'title': 'Sampah menumpuk di perumahan...',
        'status': 'Diproses',
        'statusColor': Colors.blue,
      },
      {
        'title': 'Listrik sering padam sejak 3 hari lalu.',
        'status': 'Ditolak',
        'statusColor': Colors.red,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100], // Latar belakang abu-abu terang
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian 1: Header Dashboard Admin dengan Gradient
              _buildHeader(context),

              // Bagian 2: Daftar Laporan
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daftar Laporan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Loop untuk menampilkan setiap item laporan
                    ...dummyReports.map((report) {
                      return _buildReportCard(
                        title: report['title']!,
                        status: report['status']!,
                        statusColor: report['statusColor']!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailLaporanPage(),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget untuk Header (Bagian Gradient Atas) ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200, // Tinggi yang cukup untuk area header
      decoration: BoxDecoration(
        color: Colors.white, // Warna dasar container
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Text 'Dashboard Admin' di luar card utama
          const Padding(
            padding: EdgeInsets.only(top: 20.0, left: 25.0),
            child: Text(
              'Dashboard Admin',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Card Utama dengan Gradient
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF00C9FF), // Biru Muda/Toska Terang
                    Color(0xFF92FE9D), // Hijau Muda
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00C9FF).withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Dashboard Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget untuk Card Laporan ---
  Widget _buildReportCard({
    required String title,
    required String status,
    required Color statusColor,
    required void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0.5, // Sedikit shadow
        margin: const EdgeInsets.only(bottom: 10),
        color: putihText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Laporan',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Tombol Status (Disimulasikan sebagai Container)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
