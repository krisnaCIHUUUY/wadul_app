import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/core/custom_textfield.dart';
import 'package:wadul_app/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:wadul_app/features/authentication/presentation/cubit/auth_state.dart';
import 'package:wadul_app/features/authentication/presentation/page/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _passwordController = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _namaController.dispose();
    _nikController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitRegister() {
    if (key.currentState!.validate()) {
      context.read<AuthCubit>().daftar(
        nama: _namaController.text.trim(),
        nik: _nikController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registrasi berhasil! Silakan login."),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        bool isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: putihBackgorund,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 50,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Halo!",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 45,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const Text(
                        "Selamat Datang di WADUL",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: abuAbu,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 25,
                      ),
                      child: Form(
                        key: key,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                "Daftar",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                  color: darkTosca,
                                ),
                              ),
                            ),
                            CustomTextfield(
                              obscureText: false,
                              controller: _namaController,
                              hintText: "Nama",
                              icon: Icons.person,
                              iconColor: hitamtext,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Nama tidak boleh kosong";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomTextfield(
                              obscureText: false,
                              controller: _nikController,
                              hintText: "NIK",
                              icon: Icons.person_pin_outlined,
                              iconColor: hitamtext,
                              textInputType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "NIK tidak boleh kosong";
                                }
                                if (value.length != 16 ||
                                    int.tryParse(value) == null) {
                                  return "NIK tidak valid (harus 16 digit angka)";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
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
                                if (!value.contains('@') ||
                                    !value.contains('.')) {
                                  return "Format email tidak valid";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomTextfield(
                              obscureText: true,
                              controller: _passwordController,
                              hintText: "Password",
                              icon: Icons.lock,
                              iconColor: hitamtext,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password tidak boleh kosong";
                                }
                                if (value.length < 6) {
                                  return "Password minimal 6 karakter";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: isLoading ? null : _submitRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: tosca,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Daftar",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: putihText,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Sudah punya akun? ",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      color: putihText,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return LoginPage();
                                          },
                                        ),
                                      );
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
