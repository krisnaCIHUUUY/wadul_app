import 'package:flutter/material.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';

class InstansiCard extends StatelessWidget {
  final String nama;
  final String jenis;
  final String fotoUrl;
  final void Function()? onPressed;

  const InstansiCard({
    super.key,
    required this.onPressed,
    required this.nama,
    required this.jenis,
    required this.fotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: putihText,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(fotoUrl, fit: BoxFit.cover),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  nama,

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                ),
                // SizedBox(height: 3),
                Text(jenis, style: TextStyle(fontFamily: "Poppins")),
              ],
            ),
          ),
          const Spacer(flex: 1),
          // const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: tosca),
                onPressed: onPressed,
                child: const Text("Lihat", style: TextStyle(color: putihText)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
