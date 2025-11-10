import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/core/custom_textfield.dart';
import 'package:wadul_app/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:wadul_app/features/authentication/presentation/cubit/auth_state.dart';

class LupaSandiPage extends StatefulWidget {
  const LupaSandiPage({super.key});

  @override
  State<LupaSandiPage> createState() => _LupaSandiPageState();
}

class _LupaSandiPageState extends State<LupaSandiPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isDialogShowing = false; 

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showLoading(BuildContext context) {
    if (_isDialogShowing) return; 
    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    ).then((_) {
      _isDialogShowing = false; 
    });
  }

  void _hideLoading(BuildContext context) {
    if (!mounted) return;

    if (_isDialogShowing &&
        Navigator.of(context, rootNavigator: true).canPop()) {
      try {
        Navigator.of(context, rootNavigator: true).pop();
      } catch (_) {
        // biarin aja kalau gagal pop
      } finally {
        _isDialogShowing = false;
      }
    }
  }

  void _showSnackbar(BuildContext context, String message, bool isError) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: abuAbu,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            _showLoading(context);
          } else if (state is AuthSuccess) {
            _hideLoading(context);
            _showSnackbar(context, state.message, false);
          } else if (state is AuthFailure) {
            _hideLoading(context);
            _showSnackbar(context, state.message, true);
          }
        },
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 20,
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lupa Password Anda?",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 25,
                            color: hitamtext,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Masukkan email Anda. Kami akan mengirimkan link untuk mereset password Anda.",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            color: hitamtext,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextfield(
                            obscureText: false,
                            controller: _emailController,
                            hintText: "Email",
                            icon: Icons.email,
                            iconColor: hitamtext,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email tidak boleh kosong";
                              }
                              if (!value.contains("@") ||
                                  !value.contains(".")) {
                                return "Email tidak valid";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await context.read<AuthCubit>().lupaSandi(
                                  _emailController.text.trim(),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: tosca,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              "Kirim Email Reset",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: putihText,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah ingat? ",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: putihText,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        color: darkTosca,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
