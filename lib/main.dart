import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gym_app/firebase_options.dart';
import 'package:gym_app/screens/client_home_screen.dart';
import 'package:gym_app/screens/coach_home_screen.dart';
import 'package:gym_app/screens/login_screen.dart';
import 'package:gym_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_app/screens/owner_home_screen.dart';
import 'package:gym_app/screens/secretary_home_screen.dart';
import 'package:gym_app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        final user = snapshot.data!;

        return FutureBuilder<String?>(
          future: getUserRole(user.uid),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!roleSnapshot.hasData || roleSnapshot.data == null) {
              return const Scaffold(
                body: Center(child: Text("Rol no encontrado.")),
              );
            }

            final role = roleSnapshot.data;

            switch (role) {
              case 'cli':
                return const ClientHomeScreen();
              case 'own':
                return const OwnerHomeScreen();
              case 'coa':
                return const CoachHomeScreen();
              case 'sec':
                return const SecretaryHomeScreen();
              default:
                return const Scaffold(
                  body: Center(child: Text("Rol desconocido.")),
                );
            }
          },
        );
      },
    );
  }
}
