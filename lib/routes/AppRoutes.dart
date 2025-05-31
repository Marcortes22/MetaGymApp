// lib/app_routes.dart

import 'package:flutter/material.dart';
import 'package:gym_app/screens/client/client_home_screen.dart';
import 'package:gym_app/screens/coach/coach_home_screen.dart';
import 'package:gym_app/screens/auth/login_screen.dart';
import 'package:gym_app/screens/owner/owner_home_screen.dart';
import 'package:gym_app/screens/secretary/secretary_home_screen.dart';
import 'package:gym_app/screens/auth/welcome_screen.dart';
import 'package:gym_app/screens/auth/forgot_password_screen.dart';
import 'package:gym_app/screens/auth/reset_password_screen.dart';
import 'package:gym_app/screens/auth/membership_screen.dart';
import 'package:gym_app/screens/owner/plans_screen.dart' show PlansScreen;
import 'package:gym_app/screens/owner/users_screen.dart' show UsersScreen;
import 'package:gym_app/screens/client/qr_scanner_screen.dart';
import 'package:gym_app/screens/coach/exercises_screen.dart'
    show ExercisesScreen;

class AppRoutes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String clientHome = '/client-home';
  static const String coachHome = '/coach-home';
  static const String ownerHome = '/owner-home';
  static const String secretaryHome = '/secretary-home';
  static const String memberships = '/memberships';
  static const String plans = '/plans';
  static const String users = '/users';
  static const String qrScanner = '/qr-scanner';
  static const String exercises = '/exercises';

  static Map<String, WidgetBuilder> routes = {
    welcome: (_) => const WelcomeScreen(),
    login: (_) => const LoginScreen(),
    forgotPassword: (_) => const ForgotPasswordScreen(),
    resetPassword: (_) => const ResetPasswordScreen(),
    clientHome: (_) => const ClientHomeScreen(),
    coachHome: (_) => const CoachHomeScreen(),
    ownerHome: (_) => const OwnerHomeScreen(),
    secretaryHome: (_) => const SecretaryHomeScreen(),
    memberships: (_) => const MembershipScreen(),
    plans: (_) => const PlansScreen(),
    users: (_) => const UsersScreen(),
    qrScanner: (_) => const QRScannerScreen(),
    exercises: (_) => const ExercisesScreen(),
  };
}
