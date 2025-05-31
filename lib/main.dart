import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gym_app/firebase_options.dart';
import 'package:gym_app/screens/auth/CheckInScreen.dart';
import 'package:gym_app/screens/client/client_home_screen.dart';
import 'package:gym_app/screens/coach/coach_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_app/screens/auth/no_role_screen.dart';
import 'package:gym_app/screens/owner/owner_home_screen.dart';
import 'package:gym_app/screens/auth/role_selection_screen.dart';
import 'package:gym_app/screens/secretary/secretary_home_screen.dart';
import 'package:gym_app/screens/auth/welcome_screen.dart';
import 'package:gym_app/services/auth_service.dart';
import 'package:gym_app/routes/AppRoutes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final bool isToten = prefs.getBool('modo_toten') ?? false;

  runApp(MyApp(isToten: isToten));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final bool isToten;

  const MyApp({super.key, required this.isToten});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => isToten ? const CheckInScreen() : const RootPage(),
        ...AppRoutes.routes,
      },
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
          return const WelcomeScreen();
        }

        final user = snapshot.data!;

        return FutureBuilder<List<String?>>(
          future: getUserRoles(user.uid),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // if (!roleSnapshot.hasData || roleSnapshot.data == null) {
            //   return const Scaffold(
            //     body: Center(child: Text("Rol no encontrado.")),
            //   );
            // }

            final roles = roleSnapshot.data ?? [];

            if (roles.isEmpty) {
              return const NoRoleScreen();
            }
            if (roles.length == 1) {
              switch (roles.first) {
                case 'cli':
                  return const ClientHomeScreen();
                case 'own':
                  return const OwnerHomeScreen();
                case 'coa':
                  return const CoachHomeScreen();
                case 'sec':
                  return const SecretaryHomeScreen();
                default:
                  return const NoRoleScreen();
              }
            }
            // Si hay más de un rol, mostrar pantalla de selección
            return RoleSelectionScreen(
              roles: roles.whereType<String>().toList(),
            );
          },
        );
      },
    );
  }
}
