import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wadul_app/features/instansi/domain/entities/instansi_entity.dart';
import 'package:wadul_app/features/instansi/presentation/cubit/instansi_cubit.dart';
import 'package:wadul_app/features/report/presentation/pages/info_layanan_page.dart';
import 'package:wadul_app/features/report/presentation/widgets/instansi_card.dart';

final sl = GetIt.instance;

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late final InstansiCubit _instansiCubit;

  @override
  void initState() {
    super.initState();

    _instansiCubit = sl<InstansiCubit>();

    _instansiCubit.fetchInstansiList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InstansiCubit>(
      create: (context) => _instansiCubit,
      child: Scaffold(
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
              child: BlocBuilder<InstansiCubit, InstansiState>(
                builder: (context, state) {
                  if (state is InstansiLoading || state is InstansiInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // State 2: Error
                  if (state is InstansiError) {
                    return Center(
                      child: Text(
                        'Gagal memuat instansi: ${state.message}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (state is InstansiLoaded) {
                    final List<InstansiEntity> instansiList =
                        state.instansiList;
                    if (instansiList.isEmpty) {
                      return const Center(
                        child: Text('Tidak ada instansi yang tersedia.'),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: instansiList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 10,

                            childAspectRatio: 0.85,
                          ),
                      itemBuilder: (context, index) {
                        final instansi = instansiList[index];
                        return InstansiCard(
                          nama: instansi.nama,
                          jenis: instansi.jenis,
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        InfoLayananPage(instansi: instansi),
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                transitionDuration: Duration(milliseconds: 400),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
