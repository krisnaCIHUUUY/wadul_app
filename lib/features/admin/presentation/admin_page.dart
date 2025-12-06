// lib/pages/admin_page.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/core/custom_textfield.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  Future<void> _loginAdmin() async {
    final email = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Email dan password wajib diisi');
      return;
    }

    setState(() => loading = true);

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user?.uid;
      if (uid == null) {
        await FirebaseAuth.instance.signOut();
        _showError('Gagal mendapatkan UID pengguna');
        log("gagal mendapatkan UID pengguna");
        return;
      }

      final adminDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final isAdmin = adminDoc.exists && adminDoc.data()?['isAdmin'] == true;

      if (!isAdmin) {
        // bukan admin -> logout & kabur
        await FirebaseAuth.instance.signOut();
        _showError('Akses ditolak. Akun ini bukan admin.');
        // log(userCredential.toString());
        return;
      }

      // valid admin -> masuk dashboard
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/admin-dashboard');
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Login gagal');
    } catch (e) {
      _showError('Terjadi kesalahan: $e');
      log(e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: putihBackground,
      appBar: AppBar(
        backgroundColor: putihBackground,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "ADMIN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 45,
                  fontFamily: 'Poppins',
                  color: hitamtext,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CustomTextfield(
                      controller: usernameController,
                      hintText: "Email admin",
                      obscureText: false,
                    ),
                    const SizedBox(height: 20),
                    CustomTextfield(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: loading ? null : _loginAdmin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tosca,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: loading
                      ? SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: putihText,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Masuk",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: putihText,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
              // const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
