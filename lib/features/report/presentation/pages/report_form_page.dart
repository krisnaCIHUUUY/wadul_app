import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/core/custom_textfield.dart';
import 'package:wadul_app/features/report/domain/entities/report_entity.dart';
import 'package:wadul_app/features/report/presentation/cubit/report_cubit.dart';
import 'package:wadul_app/features/report/presentation/cubit/report_state.dart';

final sl = GetIt.instance;
final supabase = Supabase.instance.client;
const _bucketName = "report_image";

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
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    judulController.dispose();
    deskripsiController.dispose();
    kategoriController.dispose();
    lokasiController.dispose();
    super.dispose();
  }

  Future<String> _uploadImageToSupabase(File file, String userId) async {
    try {
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileExtension = file.path.split('.').last;
      final String fileName = 'report_${userId}_$timestamp.$fileExtension';

      await supabase.storage
          .from(_bucketName)
          .upload(
            fileName,
            file,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
              // headers: {"authorization": ''},
            ),
          );

      // Dapatkan URL publik
      final String publicUrl = supabase.storage
          .from(_bucketName)
          .getPublicUrl(fileName);
      return publicUrl;
    } on StorageException catch (e) {
      print(e.message);
      throw Exception('Supabase Storage Error: ${e.message}');
    } catch (e) {
      throw Exception('Kesalahan tidak terduga saat upload: ${e.toString()}');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void _submitReport(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<ReportCubit>().emit(ReportLoading());

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

    String finalPhotoUrl = 'http://default_no_photo.jpg';

    try {
      if (_pickedImage != null) {
        finalPhotoUrl = await _uploadImageToSupabase(
          _pickedImage!,
          currentUserId,
        );
      }

      final newReport = ReportEntity(
        id: null,
        judul: judulController.text,
        deskripsi: deskripsiController.text,
        kategori: kategoriController.text,
        lokasi: lokasiController.text,
        buktiFotoURL: finalPhotoUrl,
        tanggal: DateTime.now(),
        userId: currentUserId,
        status: 'Pending',
      );

      await context.read<ReportCubit>().createReport(newReport);
    } catch (e) {
      context.read<ReportCubit>().emit(
        ReportFailure(e.toString().replaceAll("Exception: ", "")),
      );
    }
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
            const SizedBox(height: 10),
            CustomTextfield(
              controller: deskripsiController,
              hintText: "deskripsi",
              obscureText: false,
              validator: (value) => value == null || value.isEmpty
                  ? 'Deskripsi wajib diisi'
                  : null,
            ),
            const SizedBox(height: 10),

            CustomTextfield(
              controller: kategoriController,
              hintText: "kategori",
              obscureText: false,
            ),
            const SizedBox(height: 10),

            CustomTextfield(
              controller: lokasiController,
              hintText: "lokasi",
              obscureText: false,
            ),
            const SizedBox(height: 10),

            Container(
              padding: EdgeInsets.only(left: 50, right: 10),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: putihText,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _pickedImage != null
                          ? 'File: ${_pickedImage!.path.split('/').last}'
                          : "Tambahkan Foto Bukti",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15,
                        color: _pickedImage != null
                            ? Colors.black87
                            : Colors.grey,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: _pickImage,
                    icon: Icon(Icons.file_download_outlined),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

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
