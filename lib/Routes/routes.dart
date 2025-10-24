import 'package:voyzo/Authentication/forgot_password_screen.dart';
import 'package:voyzo/Authentication/login_screen.dart';
import 'package:voyzo/Authentication/otp_verification_screen.dart';
import 'package:voyzo/Authentication/set_new_password_screen.dart';
import 'package:voyzo/Authentication/sign_up_screen.dart';
import 'package:voyzo/HomeAndOrder/home_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String login = '/login';
  static const String home = '/home';
  static const String register = '/register';
  static const String forgot = '/forgot';
  static const String otpVerification = '/otpVerification';
  static const String newPassword = '/newPassword';
}

class CustomRouter {
  static Route<dynamic> allRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      /// Login Screen
      case Routes.login:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );

      /// Home Screen
      case Routes.home:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );

      /// Register Screen
      case Routes.register:
        return MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        );

      /// Forgot Password Screen
      case Routes.forgot:
        return MaterialPageRoute(
          builder: (context) => const ForgotPasswordScreen(),
        );

      /// Verification Screen
      case Routes.otpVerification:
        Map<String, dynamic> data =
            routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(
            data: data,
          ),
        );

      /// Set Password Screen
      case Routes.newPassword:
        return MaterialPageRoute(
          builder: (context) => const SetNewPasswordScreen(),
        );
    }
    return MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    );
  }
}
