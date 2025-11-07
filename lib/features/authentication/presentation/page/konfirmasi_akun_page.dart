import 'package:flutter/material.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/core/custom_textfield.dart';

class KonfirmasiAkunPage extends StatefulWidget {
  const KonfirmasiAkunPage({super.key});

  @override
  State<KonfirmasiAkunPage> createState() => _KonfirmasiAkunPageState();
}

class _KonfirmasiAkunPageState extends State<KonfirmasiAkunPage> {
  final _kodeController = TextEditingController();

  @override
  void dispose() {
    _kodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: abuAbu,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // MASUKKAN EMAIL ANDA
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                  // color: Colors.amber,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Konfirmasi Akun Anda",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                          color: hitamtext,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Kami telah mengirim kode ke akun anda",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: hitamtext,
                        ),
                      ),
                      Text(
                        "Masukkan kode tersebut untuk reset sandi anda",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: hitamtext,
                        ),
                      ),
                    ],
                  ),
                ),

                // FORM
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Form(
                    child: Column(
                      children: [
                        CustomTextfield(
                          obscureText: false,
                          controller: _kodeController,
                          hintText: "Masukkan Kode",
                          icon: Icons.email,
                          iconColor: hitamtext,
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            // Tambahkan logika login di sini
                            
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tosca,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            "lanjutkan",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: putihText,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            // LOGIC UNTUK KIRIM KODE KE EMAIL
                          },
                          child: Text(
                            "Kirim kode lagi",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // GHJHFJDXTYYTK
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sudah punya akun? ",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: putihText,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    //
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: "Poppins",

                      fontWeight: FontWeight.bold,
                      color: darkTosca,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
