import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/features/authentication/presentation/cubit/auth_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: putihBackgorund,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AuthCubit>().logout();
          },
          child: Text("logout"),
        ),
      ),
    );
  }
}
