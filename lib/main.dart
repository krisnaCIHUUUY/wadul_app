import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:wadul_app/core/injection_container.dart' as di;
import 'package:wadul_app/features/admin/presentation/admin_dashboard.dart';
import 'package:wadul_app/features/admin/presentation/admin_page.dart';
import 'package:wadul_app/features/authentication/data/datasource/auth_firebase_data_source.dart';
import 'package:wadul_app/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:wadul_app/features/authentication/domain/usecases/get_current_user.dart';
import 'package:wadul_app/features/authentication/domain/usecases/user_daftar.dart';
import 'package:wadul_app/features/authentication/domain/usecases/user_logout.dart';
import 'package:wadul_app/features/authentication/domain/usecases/user_lupa_sandi.dart';
import 'package:wadul_app/features/authentication/domain/usecases/user_masuk.dart';
import 'package:wadul_app/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:wadul_app/features/authentication/presentation/page/login_page.dart';
import 'package:wadul_app/features/authentication/presentation/page/register_page.dart';
import 'package:wadul_app/features/super_admin/presentation/pages/super_admin_page.dart';
import 'package:wadul_app/home_page.dart';
import 'package:wadul_app/features/authentication/presentation/page/onboarding_page.dart';
import 'package:wadul_app/firebase_options.dart';

const supabaseUrl = "https://riiqdykoybbrflfrpyoe.supabase.co";
const anonKey =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJpaXFkeWtveWJicmZsZnJweW9lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1NTIyOTMsImV4cCI6MjA3OTEyODI5M30.MDyuiJmT8fSr-MKcqgzzq7jjPVbpuVLwTx6p3jl-QCY";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: anonKey);
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
  final currenUser = GetCurrentUser(repository);

  await di.initDependencies();

  runApp(
    MyApp(
      userDaftar: userDaftar,
      userMasuk: userMasuk,
      userLogout: userLogout,
      userLupaSandi: userLupaSandi,
      currentUser: currenUser,
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserDaftar userDaftar;
  final UserMasuk userMasuk;
  final UserLogout userLogout; 
  final UserLupaSandi userLupaSandi;
  final GetCurrentUser currentUser;

  const MyApp({
    super.key,
    required this.userDaftar,
    required this.userMasuk,
    required this.userLogout,
    required this.userLupaSandi,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(
            userDaftar,
            userMasuk,
            userLogout,
            userLupaSandi,
            currentUser,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WADUL',
        initialRoute: '/',
        routes: {
          "/onboarding": (context) => OnboardingPage(),
          "/admin-dashboard": (context) => AdminDashboardPage(),
          "/admin-login": (context) => AdminPage(),
          "/register-page": (context) => RegisterPage(),
          "/login-page": (context) => LoginPage(),
          "/home-page": (context) => HomePage(),
          "/super-admin-page": (context) => SuperAdminPage(),
        },
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
              if (snapshot.data!.email == "superadmin123@gmail.com") {
                return SuperAdminPage();
              }
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
