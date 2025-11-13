import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wadul_app/features/authentication/presentation/cubit/auth_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: ElevatedButton(
      //     onPressed: () => Navigator.pop(context),
      //     child: Icon(Icons.arrow_back_ios),
      //   ),
      // ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AuthCubit>().logout();
            Navigator.pop(context);
          },
          child: Text("logout"),
        ),
      ),
    );
  }
}
