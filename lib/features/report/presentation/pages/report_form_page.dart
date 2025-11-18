import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/core/custom_textfield.dart';
import 'package:wadul_app/features/report/domain/entities/report_entity.dart';
import 'package:wadul_app/features/report/presentation/cubit/report_cubit.dart';
import 'package:wadul_app/features/report/presentation/cubit/report_state.dart';

final sl = GetIt.instance;

class ReportFormPage extends StatefulWidget {
  const ReportFormPage({super.key});

  @override
  State<ReportFormPage> createState() => _ReportFormPageState();
}

class _ReportFormPageState extends State<ReportFormPage> {
  final _formKey = GlobalKey<FormState>();
  final judulController = TextEditingController();
  final deskripsiController = TextEditingController();
  final kategoriController = TextEditingController();
  final lokasiController = TextEditingController();
  final tambahFotoController = TextEditingController();

  @override
  void dispose() {
    judulController.dispose();
    deskripsiController.dispose();
    kategoriController.dispose();
    lokasiController.dispose();
    tambahFotoController.dispose();
    super.dispose();
  }

 void _submitReport(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final auth = FirebaseAuth.instance;
    final currentUserId = auth.currentUser?.uid;
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Anda harus login untuk membuat laporan.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final newReport = ReportEntity(
      id: null,
      judul: judulController.text,
      deskripsi: deskripsiController.text,
      kategori: kategoriController.text,
      lokasi: lokasiController.text,
      buktiFotoURL: tambahFotoController.text.isNotEmpty
          ? tambahFotoController.text
          : 'http://default_no_photo.jpg',
      tanggal: DateTime.now(),
      userID: currentUserId,
      status: 'Pending',
    );

    context.read<ReportCubit>().createReport(newReport);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReportCubit>(),
      child: Scaffold(
        body: BlocListener<ReportCubit, ReportState>(
          listener: (context, state) {
            if (state is ReportSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Future.delayed(const Duration(milliseconds: 1500), () {
                Navigator.pop(context);
              });
            } else if (state is ReportFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Gagal: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 280,
                child: Image.asset('assets/polres.jpg', fit: BoxFit.cover),
              ),

              Positioned(
                top: 40,
                left: 15,
                child: CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: putihText),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              Positioned(
                top: 250,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: putihBackground,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: _buildFormContent(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            CustomTextfield(
              controller: judulController,
              hintText: "judul",
              obscureText: false,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Judul wajib diisi' : null,
            ),
            const SizedBox(height: 20),
            CustomTextfield(
              controller: deskripsiController,
              hintText: "deskripsi",
              obscureText: false,
              validator: (value) => value == null || value.isEmpty
                  ? 'Deskripsi wajib diisi'
                  : null,
            ),
            const SizedBox(height: 20),

            CustomTextfield(
              controller: kategoriController,
              hintText: "kategori",
              obscureText: false,
            ),
            const SizedBox(height: 20),

            CustomTextfield(
              controller: lokasiController,
              hintText: "lokasi",
              obscureText: false,
            ),
            const SizedBox(height: 20),

            CustomTextfield(
              controller: tambahFotoController,
              hintText: "tambah foto",
              obscureText: false,
            ),
            const SizedBox(height: 20),
            BlocBuilder<ReportCubit, ReportState>(
              builder: (context, state) {
                final bool isLoading = state is ReportLoading;

                return ElevatedButton(
                  onPressed: isLoading ? null : () => _submitReport(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tosca,
                    minimumSize: Size(200, 50),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: putihText,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Kirim Laporan",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: putihText,
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
