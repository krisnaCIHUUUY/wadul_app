import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/features/authentication/presentation/utils/onboarding_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  final String superAdminEmail = 'superadmin123@gmail.com';
  final String superAdminPassword = 'superadmin123';

  Future<void> _handleSuperAdminLogin(BuildContext context) async {
    // Tampilkan indikator loading (opsional tapi disarankan)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: superAdminEmail,
            password: superAdminPassword,
          );

          
      log('Super Admin login berhasil: ${userCredential.user!.uid}');

      Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, "/super-admin-page");
    } on FirebaseAuthException catch (e) {
      // Tutup indikator loading
      Navigator.of(context).pop();

      log('Login Super Admin Gagal: ${e.code}');
      String errorMessage =
          'Login gagal. Email/password salah atau akun tidak ditemukan.';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      // Tutup indikator loading
      Navigator.of(context).pop();

      log('Error tidak terduga: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan saat masuk.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tosca,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Image.asset(
                  'assets/wadul_logo.png',
                  fit: BoxFit.contain,
                  width: 300,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Selamat datang di WADUL 👋",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  color: putihText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Pilih cara untuk mulai menggunakan aplikasi.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: putihText.withOpacity(0.9),
                ),
              ),
              const Spacer(),
              OnboardingButton(
                title: 'Daftar Akun',
                onPressed: () {
                  log('Navigasi ke halaman pendaftaran');
                  Navigator.pushNamed(context, "/register-page");
                },
              ),
              const SizedBox(height: 15),
              OnboardingButton(
                title: 'Masuk',
                onPressed: () {
                  log('Navigasi ke halaman login');
                  Navigator.pushNamed(context, "/login-page");
                },
              ),
              const SizedBox(height: 15),
              OnboardingButton(
                title: 'Masuk sebagai Tamu',
                onPressed: () {
                  log('Masuk sebagai guest');
                  // Arahkan ke halaman utama
                  Navigator.pushNamed(context, "/home-page");
                },
              ),
              const SizedBox(height: 15),
              OnboardingButton(
                title: "admin",
                onPressed: () {
                  Navigator.pushNamed(context, "/admin-login");
                },
              ),
              const SizedBox(height: 15),
              OnboardingButton(
                title: "Super Admin",
                onPressed: () async {
                  await _handleSuperAdminLogin(context);
                  
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
