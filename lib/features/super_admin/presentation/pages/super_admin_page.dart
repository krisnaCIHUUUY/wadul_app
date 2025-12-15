import 'package:flutter/material.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/features/authentication/presentation/page/onboarding_page.dart';
import 'package:wadul_app/features/super_admin/data/datasource/firestore_service.dart';
import 'package:wadul_app/features/super_admin/presentation/pages/daftar_pengguna.dart';
import 'package:wadul_app/features/super_admin/presentation/pages/statistik_page.dart';
import 'package:wadul_app/features/super_admin/presentation/pages/tambah_penguna.dart';

class SuperAdminPage extends StatefulWidget {
  const SuperAdminPage({super.key});

  @override
  State<SuperAdminPage> createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<SuperAdminPage> {
  int indexSelected = 0;
  List<IconData> navbars = [Icons.person, Icons.stacked_line_chart_rounded];

  List<Widget> pages = [DaftarPengguna(), StatistikPage()];

  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _handleLogout() async {
    try {
      await _firestoreService.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const OnboardingPage(),
        ), // Ganti dengan widget Onboarding Anda
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', 'Gagal: ')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: putihText,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 20,
              spreadRadius: 10,
            ),
          ],
        ),
        height: 85,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: navbars.map((navbar) {
            int selected = navbars.indexOf(navbar);
            bool isSelected = selected == indexSelected;
            return GestureDetector(
              onTap: () {
                setState(() {
                  indexSelected = selected;
                });
              },
              child: Icon(
                navbar,
                size: 35,
                color: isSelected ? tosca : hitamtext,
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahPengguna()),
          );
        },
        backgroundColor: darkTosca,
        child: Icon(Icons.add, color: putihText, size: 30),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Stack(
                children: [
                  Container(
                    height: 210,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00C9FF), // Biru Muda/Toska Terang
                          Color(0xFF92FE9D), // Hijau Muda
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Dashboard Super Admin",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentGeometry.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: _handleLogout,
                        icon: Icon(
                          Icons.logout_outlined,
                          size: 30,
                          color: putihText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 180,
              left: 0,
              right: 0,
              bottom: 0,
              child: pages[indexSelected],
            ),
          ],
        ),
      ),
    );
  }
}
