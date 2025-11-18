import 'package:flutter/material.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/features/report/presentation/pages/info_layanan_page.dart';

class InstansiCard extends StatelessWidget {
  const InstansiCard({super.key});

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
                child: Image.asset("assets/polres.jpg", fit: BoxFit.cover),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Title",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 3),
                Text("Description", style: TextStyle(fontFamily: "Poppins")),
              ],
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: tosca),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          InfoLayananPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                      transitionDuration: Duration(milliseconds: 400),
                    ),
                  );
                },
                child: const Text("Lihat", style: TextStyle(color: putihText)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
