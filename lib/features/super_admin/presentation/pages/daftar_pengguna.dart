import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/features/super_admin/data/datasource/firestore_service.dart';
import 'package:wadul_app/features/super_admin/data/model/users_model.dart';
import 'package:wadul_app/features/super_admin/presentation/widgets/person_card.dart';

class DaftarPengguna extends StatefulWidget {
  const DaftarPengguna({super.key});

  @override
  State<DaftarPengguna> createState() => _DaftarPenggunaState();
}

class _DaftarPenggunaState extends State<DaftarPengguna> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Center(
              child: Text(
                "Daftar Pengguna",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<List<UsersModel>>(
              stream: _firestoreService.getUsers(),
              builder: (context, snapshot) {
                // --- 1. Cek Loading ---
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // --- 2. Cek Error ---
                if (snapshot.hasError) {
                  log('Error mengambil data: ${snapshot.error}');
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Terjadi error saat mengambil data: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: hitamtext),
                      ),
                    ),
                  );
                }

                // --- 3. Cek Data Kosong ---
                final users = snapshot.data;
                if (users == null || users.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada data pengguna yang tersedia.',
                      style: TextStyle(color: hitamtext),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return PersonCard(nama: user.nama, email: user.email);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
