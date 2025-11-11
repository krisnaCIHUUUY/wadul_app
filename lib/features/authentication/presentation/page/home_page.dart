import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/features/authentication/presentation/cubit/auth_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: putihBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // BAGIAN HEADER E
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 110,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/wadul_logo.png',
                      fit: BoxFit.contain,
                      height: 200,
                    ),
                    CircleAvatar(radius: 35, child: Icon(Icons.person)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // BAGIAN SEARCH BAR E
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  fillColor: putihBackground,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(width: 2, color: tosca),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.search, size: 30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // BAGIAN TITLE + TOMBOL VIEW ALL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                // color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pupolar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'View all',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // TOMBOL HARI INI + SENG WS TERTANGANI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                // color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                          side: BorderSide.none,
                        ),
                        backgroundColor: hitamtext,
                        fixedSize: Size.fromWidth(150),
                      ),
                      child: Text(
                        'Hari ini',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: putihText,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                          side: BorderSide(width: 2, color: hitamtext),
                        ),
                        backgroundColor: putihBackground,
                        fixedSize: Size.fromWidth(150),
                      ),
                      child: Text(
                        'tertangani',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: hitamtext,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            //BAGIAN GRIDVIEW KANGGO ARTIKEL/ CARD E

            // CUEKIN
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<AuthCubit>().logout();
                },
                child: Text("logout"),
              ),
            ),

            // BOTTOM NAVIGATION BAR E
          ],
        ),
      ),
    );
  }
}
