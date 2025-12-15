import 'package:flutter/material.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';

class PersonCard extends StatelessWidget {
  final String nama;
  final String email;
  final  void Function()? onTap;
  const PersonCard({super.key, required this.nama, required this.email, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        leading: CircleAvatar(
          backgroundColor: tosca.withOpacity(0.2),
          child: const Icon(Icons.person, color: tosca),
        ),
        title: Text(
          nama,
          style: const TextStyle(fontWeight: FontWeight.bold, color: hitamtext),
        ),
        subtitle: Text(
          email,
          style: TextStyle(color: hitamtext.withOpacity(0.7)),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: hitamtext.withOpacity(0.5),
        ),
        onTap: onTap
      ),
    );
  }
}
