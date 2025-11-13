import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/home_page.dart';
import 'package:wadul_app/features/authentication/presentation/page/login_page.dart';
import 'package:wadul_app/features/authentication/presentation/page/register_page.dart';
import 'package:wadul_app/features/authentication/presentation/utils/onboarding_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

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
                  // Navigator.pushNamed(context, '/register');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
              ),
              const SizedBox(height: 15),
              OnboardingButton(
                title: 'Masuk',
                onPressed: () {
                  log('Navigasi ke halaman login');
                  // Navigator.pushNamed(context, '/login');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
              const SizedBox(height: 15),
              OnboardingButton(
                title: 'Masuk sebagai Tamu',
                onPressed: () {
                  log('Masuk sebagai guest');
                  // Arahkan ke halaman utama
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
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
