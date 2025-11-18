import 'package:flutter/material.dart';
import 'package:wadul_app/features/report/presentation/widgets/instansi_card.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 30, bottom: 20),
            child: Text(
              "Instansi",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 5,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 10,

                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return InstansiCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
