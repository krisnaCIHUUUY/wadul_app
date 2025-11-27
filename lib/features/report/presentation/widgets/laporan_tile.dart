import 'package:flutter/material.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';

class LaporanTile extends StatelessWidget {
  final String judul;
  final String tanggal;
  final String status;
  final Color? statusBackground;
  final Color? statusColor;
  final void Function()? onTap;
  const LaporanTile({
    super.key,
    required this.judul,
    required this.tanggal,
    required this.status,
    required this.onTap,
    this.statusBackground = menungguBackground,
    this.statusColor = menungguColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(15),
      ),
      leading: CircleAvatar(
        backgroundColor: tosca.withValues(alpha: 0.5),
        foregroundColor: darkBlue,
        child: Icon(Icons.article),
      ),
      title: Text(
        judul,
        style: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      subtitle: Text(tanggal, style: TextStyle(fontFamily: "Poppins")),
      tileColor: putihText,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
          color: statusBackground,
          borderRadius: BorderRadius.circular(90),
        ),
        child: Text(
          status,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: statusColor,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
