import 'package:flutter/material.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/features/super_admin/data/datasource/firestore_service.dart';

class TambahPengguna extends StatefulWidget {
  const TambahPengguna({super.key});

  @override
  State<TambahPengguna> createState() => _TambahPenggunaState();
}

class _TambahPenggunaState extends State<TambahPengguna> {
  final namaController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  final key = GlobalKey<FormState>();
  final String _defaultRole = "Admin";

  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (key.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _firestoreService.createUserAdmin(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          role: _defaultRole,
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Akun berhasil ditambahkan!')));
        // Kembali ke halaman sebelumnya (Daftar Pengguna)
        Navigator.of(context).pop();
      } catch (e) {
        // Tampilkan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 30,
                        color: putihText,
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
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: Center(
                          child: Text(
                            "Tambah Pengguna",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // addPenggunaField( title: "Nama", controller: namaController, ),
                      const SizedBox(height: 20),
                      addPenggunaField(
                        title: "Email",
                        controller: namaController,
                        validator: (value) =>
                            value == null || !value.contains('@')
                            ? 'Masukkan email yang valid'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      addPenggunaField(
                        title: "Password",
                        controller: passwordController,
                        validator: (value) => value == null || value.length < 6
                            ? 'Password minimal 6 karakter'
                            : null,
                      ),
                      Spacer(),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(200, 50),
                            backgroundColor: darkTosca,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(15),
                            ),
                            // padding: EdgeInsets.all(20),
                          ),
                          onPressed: _isLoading ? null : _submitForm,
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "tambah",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Poppins",
                                    color: putihText,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget addPenggunaField({
  required String title,
  required TextEditingController controller,
  required String? Function(String?) validator,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    height: 100,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: "Poppins",
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: darkBlue),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: tosca, width: 2),
            ),
          ),
        ),
      ],
    ),
  );
}
