// File: lib/widgets/custom_activity_log_table.dart

import 'package:flutter/material.dart';

// Kelas Model Dummy untuk data log
class ActivityLog {
  final int id;
  final String firstName;
  final String lastName;
  final String currentTeam;

  ActivityLog(this.id, this.firstName, this.lastName, this.currentTeam);
}

class CustomActivityLogTable extends StatelessWidget {
  final List<ActivityLog> logs;
  final String fontFamily;

  const CustomActivityLogTable({
    super.key,
    required this.logs,
    this.fontFamily = "Poppins",
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Padding di dalam card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                "Log Aktivitas", // Judul opsional, diasumsikan dari konteks
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: fontFamily,
                ),
              ),
            ),
            // Widget utama untuk Tabel
            SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal, // Memungkinkan scroll jika tabel lebar
              child: DataTable(
                columnSpacing: 20.0, // Jarak antar kolom
                dataRowMinHeight: 30.0,
                dataRowMaxHeight: 40.0,
                headingRowHeight: 40.0, // Tinggi header
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10),
                ),
                // --- Header Kolom (sesuai gambar: #, A, B, C) ---
                columns: [
                  DataColumn(label: _buildHeaderText('#', fontFamily)),
                  DataColumn(label: _buildHeaderText('First Name', fontFamily)),
                  DataColumn(label: _buildHeaderText('Last Name', fontFamily)),
                  DataColumn(
                    label: _buildHeaderText('Current Team', fontFamily),
                  ),
                ],
                // --- Baris Data ---
                rows: logs
                    .map(
                      (log) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              log.id.toString(),
                              style: _buildDataTextStyle(fontFamily),
                            ),
                          ),
                          DataCell(
                            Text(
                              log.firstName,
                              style: _buildDataTextStyle(fontFamily),
                            ),
                          ),
                          DataCell(
                            Text(
                              log.lastName,
                              style: _buildDataTextStyle(fontFamily),
                            ),
                          ),
                          DataCell(
                            Text(
                              log.currentTeam,
                              style: _buildDataTextStyle(fontFamily),
                            ),
                          ),
                        ],
                        color: log.id.isOdd
                            ? MaterialStateProperty.all(
                                Colors.grey.shade50,
                              ) // Warna baris ganjil
                            : null, // Biarkan baris genap putih
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Gaya teks untuk header
  Widget _buildHeaderText(String text, String fontFamily) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black,
        fontFamily: fontFamily,
      ),
    );
  }

  // Gaya teks untuk data cell
  TextStyle _buildDataTextStyle(String fontFamily) {
    return TextStyle(
      fontSize: 12,
      color: Colors.black87,
      fontFamily: fontFamily,
    );
  }
}
