import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wadul_app/features/authentication/domain/usecases/get_current_user.dart';
import 'package:wadul_app/features/authentication/domain/usecases/user_daftar.dart';
import 'package:wadul_app/features/authentication/domain/usecases/user_logout.dart';
import 'package:wadul_app/features/authentication/domain/usecases/user_lupa_sandi.dart';
import 'package:wadul_app/features/authentication/domain/usecases/user_masuk.dart';
import 'package:wadul_app/features/authentication/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserDaftar userDaftar;
  final UserMasuk userMasuk;
  final UserLogout userLogout;
  final UserLupaSandi userLupaSandi;
  final GetCurrentUser getCurrentUser;
  AuthCubit(
    this.userDaftar,
    this.userMasuk,
    this.userLogout,
    this.userLupaSandi,
    this.getCurrentUser,
  ) : super(AuthInitial());

  Future<void> daftar({
    required String nama,
    required String nik,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final userEntity = await userDaftar.call(
        nama: nama,
        nik: nik,
        email: email,
        password: password,
      );

      userEntity.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (uid) => emit(AuthSuccess(uid.toString())),
      );
    } catch (e) {}
  }

  Future<void> masuk({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final userEntity = await userMasuk.call(email: email, password: password);

      userEntity.fold(
        (failure) {
          emit(AuthFailure(failure.message));
        },
        (message) {
          emit(AuthSuccess(message.toString()));
        },
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Terjadi kesalahan autentikasi.'));
    } catch (e) {
      emit(AuthFailure('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  void logout() async {
    emit(AuthLoading());
    final result = await userLogout.call();
    result.fold(
      (failure) {
        return AuthFailure(failure.message);
      },
      (success) {
        print(success);
        emit(AuthInitial());
      },
    );
  }

  Future<void> lupaSandi(String email) async {
    emit(AuthLoading());
    final result = await userLupaSandi.call(email);
    result.fold(
      (failure) {
        emit(AuthFailure(failure.message));
      },
      (success) {
        emit(AuthSuccess(success));
      },
    );
  }

  Future<void> currentUser() async {
    emit(AuthLoading());
    final currentUser = await getCurrentUser.call();
    currentUser.fold(
      (failure) {
        emit(AuthFailure(failure.message));
      },
      (userEntity) {
        if (userEntity != null) {
          emit(AuthLoaded(userEntity));
        }
      },
    );
  }
}
