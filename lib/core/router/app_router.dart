import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hire_pro/core/extensions/size_extension.dart';
import 'package:hire_pro/features/auth/view/auth_screen.dart';
import 'package:hire_pro/features/home/home_screen.dart';
import 'package:hire_pro/features/profile/ui/applicant_profile_setup.dart';
import 'package:hire_pro/features/profile/ui/employer_profile_setup.dart';
import 'package:hire_pro/features/splash/splash_screen.dart';
import 'package:hire_pro/shared/widgets/buttons/primary_button.dart';
import 'package:hire_pro/shared/widgets/common_app_bar.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../constants/app_exports.dart';
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
      GoRoute(path: AppRoutes.auth, builder: (_, _) => AuthScreen()),

      GoRoute(path: AppRoutes.home, builder: (_, _) => HomeScreen()),

      GoRoute(
        path: AppRoutes.applicantProfileSetup,
        builder: (_, _) => const ApplicantProfileSetupScreen(),
      ),

      GoRoute(
        path: AppRoutes.employerProfileSetup,
        builder: (_, _) => const EmployerProfileSetupScreen(),
      ),
    ],

    errorBuilder: (context, state) => NoPageFoundScreen(),
  );
}

class NoPageFoundScreen extends StatelessWidget {
  const NoPageFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Page Not Found', centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.s24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/image/404.svg',
                height: context.heightFraction(.35),
              ),
              SizedBox(height: AppSizes.s24),
              Text(
                'Page Not Found',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColor.primary,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.p8),
              Text(
                "The page you're looking for doesn't exist or has been moved.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColor.textSecondary.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.s32),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: 'Back to Dashboard',
                  onTap: () => context.go('/dashboard'), // adjust route
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
