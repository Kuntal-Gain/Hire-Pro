import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hire_pro/features/splash/splash_screen.dart';

import 'app_routes.dart';

final class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,

    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),

      // Auth
      
    ],

    errorBuilder: (context, state) {
      print("error page");
      return Scaffold(body: Center(child: Text(state.error.toString())));
    },
  );
}
