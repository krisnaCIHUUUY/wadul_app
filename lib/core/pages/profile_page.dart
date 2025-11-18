import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wadul_app/features/authentication/presentation/cubit/auth_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    // gawe halaman profile untuk user yang telah login
    // context.read<AuthCubit>().getCurrentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<AuthCubit>().logout();
              },
              child: Text("logout"),
            ),
          ),
        ],
      ),
    );
  }
}
