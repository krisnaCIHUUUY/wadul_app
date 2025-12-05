import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/features/authentication/presentation/cubit/auth_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: putihBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: darkTosca,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(150),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: IconButton(
                    onPressed: () {
                      context.read<AuthCubit>().logout();
                      Navigator.pushReplacementNamed(context, "/onboarding");
                    },
                    icon: Icon(Icons.logout, color: putihText, size: 30),
                  ),
                ),
              ),

              Positioned(
                bottom: -50,
                left: 0,
                right: 0,
                child: Align(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/profile.jpg'),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: putihText,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: ListTile(
              onTap: () {
                // NAMPILKE HALAMAN DETAIL PROFILE
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
              tileColor: putihText,
              title: Text(
                "Profil saya",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(Icons.person, color: tosca),
              subtitle: Text("Nama, no.HP, NIK, email,"),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: ListTile(
              onTap: () {
                // NAMPILKE BANTUAN DAN LAYANAN
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
              tileColor: putihText,
              title: Text(
                "Bantuan dan Layanan",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(Icons.person, color: tosca),
              subtitle: Text("Layanan pelanggan"),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: ListTile(
              onTap: () {
                // NAMPILKE TENTANG APLIKASI
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
              tileColor: putihText,
              title: Text(
                "tentang Aplikasi",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(Icons.person, color: tosca),
              subtitle: Text("Informasi Aplikasi"),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: ListTile(
              onTap: () {
                // ULASAN RENG PLAYSTORE
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
              tileColor: putihText,
              title: Text(
                "Ulasan Aplikasi",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(Icons.person, color: tosca),
              subtitle: Text("Playstore Rating"),
            ),
          ),
        ],
      ),
    );
  }
}
