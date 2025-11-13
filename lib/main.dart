import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wadul_app/features/authentication/data/datasource/auth_firebase_data_source.dart';
import 'package:wadul_app/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:wadul_app/features/authentication/domain/usecases/user_daftar.dart';
import 'package:wadul_app/features/authentication/domain/usecases/user_logout.dart';
import 'package:wadul_app/features/authentication/domain/usecases/user_lupa_sandi.dart';
import 'package:wadul_app/features/authentication/domain/usecases/user_masuk.dart';
import 'package:wadul_app/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:wadul_app/home_page.dart';
import 'package:wadul_app/features/authentication/presentation/page/onboarding_page.dart';
import 'package:wadul_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final dataSource = AuthFirebaseDataSourceImpl(
    firebaseAuth: firebaseAuth,
    firebaseFirestore: firebaseFirestore,
  );
  final repository = AuthRepositoryImpl(dataSource: dataSource);
  final userDaftar = UserDaftar(repository);
  final userMasuk = UserMasuk(repository);
  final userLogout = UserLogout(repository);
  final userLupaSandi = UserLupaSandi(repository);

  runApp(
    MyApp(
      userDaftar: userDaftar,
      userMasuk: userMasuk,
      userLogout: userLogout,
      userLupaSandi: userLupaSandi,
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserDaftar userDaftar;
  final UserMasuk userMasuk;
  final UserLogout userLogout;
  final UserLupaSandi userLupaSandi;

  const MyApp({
    super.key,
    required this.userDaftar,
    required this.userMasuk,
    required this.userLogout,
    required this.userLupaSandi,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              AuthCubit(userDaftar, userMasuk, userLogout, userLupaSandi),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WADUL',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return OnboardingPage();
            }
          },
        ),
      ),
    );
  }
}
