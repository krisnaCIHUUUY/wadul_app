import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wadul_app/features/instansi/domain/entities/instansi_entity.dart';
import 'package:wadul_app/features/instansi/domain/repository/instansi_repository.dart';

part 'instansi_state.dart';

class InstansiCubit extends Cubit<InstansiState> {
  final InstansiRepository repository;

  InstansiCubit({required this.repository}) : super(InstansiInitial());

  Future<void> fetchInstansiList() async {
    // Jangan load ulang jika sudah ada data
    if (state is InstansiLoaded) return;

    emit(InstansiLoading());
    try {
      final instansiList = await repository.fetchAllInstansi();
      emit(InstansiLoaded(instansiList));
    } catch (e) {
      emit(InstansiError(e.toString()));
    }
  }
}
