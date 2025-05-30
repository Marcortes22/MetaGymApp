// lib/app_routes.dart

import 'package:flutter/material.dart';
import 'package:gym_app/screens/Client/client_home_screen.dart';
import 'package:gym_app/screens/Coach/coach_home_screen.dart';
import 'package:gym_app/screens/Auth/login_screen.dart';
// import 'package:gym_app/screens/home_screen.dart';
import 'package:gym_app/screens/Owner/owner_home_screen.dart';
import 'package:gym_app/screens/secretary/secretary_home_screen.dart';
import 'package:gym_app/screens/Auth/welcome_screen.dart';
import 'package:gym_app/screens/Auth/forgot_password_screen.dart';
import 'package:gym_app/screens/Auth/reset_password_screen.dart';

class AppRoutes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String clientHome = '/client-home';
  static const String coachHome = '/coach-home';
  static const String ownerHome = '/owner-home';
  static const String secretaryHome = '/secretary-home';

  static Map<String, WidgetBuilder> routes = {
    welcome: (_) => const WelcomeScreen(),
    login: (_) => const LoginScreen(),
    forgotPassword: (_) => const ForgotPasswordScreen(),
    resetPassword: (_) => const ResetPasswordScreen(),
    clientHome: (_) => const ClientHomeScreen(),
    coachHome: (_) => const CoachHomeScreen(),
    ownerHome: (_) => const OwnerHomeScreen(),
    secretaryHome: (_) => const SecretaryHomeScreen(),
  };
}
