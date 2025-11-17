import 'package:flutter/material.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/features/report/presentation/pages/report_form_page.dart';

class InfoLayananPage extends StatelessWidget {
  const InfoLayananPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: Image.asset('assets/polres.jpg', fit: BoxFit.cover),
          ),

          Positioned(
            top: 40,
            left: 15,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: putihText),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          Positioned(
            top: 250,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Judul Layanan",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Ini adalah deskripsi layanan yang bisa kamu isi sesuai kebutuhan. "
                      "Gunakan untuk menjelaskan detail layanan, jam operasional, "
                      "alamat, kontak, dan hal penting lainnya.",
                      style: TextStyle(fontSize: 16, fontFamily: "Poppins"),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Informasi Tambahan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "• Alamat lengkap: Jl. Contoh No.123\n"
                      "• Jam operasional: 08.00 - 16.00\n"
                      "• Kontak: 0812-3456-7890",
                      style: TextStyle(fontSize: 16, fontFamily: "Poppins"),
                    ),

                    const SizedBox(height: 30),

                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportFormPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 14,
                          ),
                          backgroundColor: tosca,
                        ),
                        child: Text(
                          "Ajukan Layanan",
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: "Poppins",
                            color: putihText,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
