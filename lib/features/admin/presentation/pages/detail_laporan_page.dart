import 'package:flutter/material.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';

class DetailLaporanPage extends StatelessWidget {
  const DetailLaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: putihBackground,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF00C9FF),
                      Color(0xFF92FE9D), // Hijau Muda
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              size: 30,
                              color: putihText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: const Text(
                        'Detail Laporan',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          color: putihText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    detailLaporanCard(
                      title: "Judul Laporan",
                      subtitle: "loremddibfvwkdsccwev",
                      cardColor: putihText,
                      isMultiline: true,
                    ),
                    const SizedBox(height: 10),
                    detailLaporanCard(
                      title: "Deskripsi",
                      subtitle: "yayayayayayayay",
                      cardColor: putihText,
                      isMultiline: true,
                    ),
                    const SizedBox(height: 10),
                    detailLaporanCard(
                      title: "Lokasi",
                      subtitle: "ngawi selatan",
                      cardColor: putihText,
                      isMultiline: true,
                    ),
                    const SizedBox(height: 10),

                    detailLaporanCard(
                      title: "Status",
                      subtitle: "Menunggu Verifikasi",
                      cardColor: putihText,
                      isMultiline: false,
                    ),

                    const SizedBox(height: 10),
                    fotoLaporanCard(
                      title: "foto",
                      cardColor: putihText,
                      url: "assets/polres.jpg",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget detailLaporanCard({
  required String title,
  required String subtitle,
  required Color cardColor,
  required bool isMultiline,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10), // Jarak dikecilkan
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          constraints: BoxConstraints(minHeight: 50),
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: "Poppins",
              color: Colors.black54,
            ),
            maxLines: isMultiline
                ? null
                : 1, // Jika tidak multiline, batasi 1 baris
            overflow: isMultiline ? TextOverflow.clip : TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget fotoLaporanCard({
  required String title,
  // required String subtitle,
  required Color cardColor,
  // required bool isMultiline,
  required String url,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10), // Jarak dikecilkan
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          constraints: BoxConstraints(minHeight: 50),
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Image.asset(url, fit: BoxFit.scaleDown, height: 150),
        ),
      ],
    ),
  );
}
