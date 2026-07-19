import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hire_pro/core/constants/color_constants.dart';
import 'package:hire_pro/core/constants/sizes_constants.dart';
import 'package:hire_pro/core/extensions/size_extension.dart';
import 'package:hire_pro/core/network/client_manager.dart';
import 'package:hire_pro/core/router/app_routes.dart';
import 'package:hire_pro/core/utils/enums.dart';
import 'package:hire_pro/features/auth/provider/auth_provider.dart';
import 'package:hire_pro/shared/widgets/buttons/primary_button.dart';
import 'package:hugeicons_pro/hugeicons.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slideLogo;
  late final Animation<Offset> _slideButton;

  final bool _isLoggedIn = SupabaseManager.isAuthenticated;
  bool _isCheckingSession = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slideLogo = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
          ),
        );

    _slideButton = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();

    if (_isLoggedIn) {
      _resumeSession();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _resumeSession() async {
    setState(() => _isCheckingSession = true);
    try {
      await ref.read(authProvider.notifier).refresh();
      final user = ref.read(authProvider).value;

      if (!context.mounted) return;

      if (user != null && user.usertype == UserType.applicant && !user.isProfileCreated) {
        context.go(AppRoutes.applicantProfileSetup);
      }  else if(user != null && user.usertype == UserType.recruiter &&
          !user.isProfileCreated) {
            context.go(AppRoutes.employerProfileSetup);
          } else {
        context.go(AppRoutes.home);
      }
    } catch (_) {
      if (context.mounted) setState(() => _isCheckingSession = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.s24),
          child: Column(
            children: [
              const Spacer(flex: 1),
      
              // ── Icon logo block ──────────────────────────────
              FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slideLogo,
                  child: Column(
                    children: [
                      Container(
                        width: context.widthFraction(.2),
                        height: context.widthFraction(.2),
                        decoration: BoxDecoration(
                          gradient: AppColor.primaryGradient,
                          borderRadius: BorderRadius.circular(AppSizes.r24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.primary.withValues(alpha: 0.28),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.work_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(height: AppSizes.s24),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Hire',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                color: AppColor.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            TextSpan(
                              text: 'Pro',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                color: AppColor.primary,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSizes.s8),
                      Text(
                        'Great candidates. Great companies.\nZero ghosting.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      
              
      
              // ── SVG splash image ─────────────────────────────
              Expanded(
                flex: 5,
                child: Center(
                  child: FadeTransition(
                    opacity: _fade,
                    child: SlideTransition(
                      position: _slideLogo,
                      child: SvgPicture.asset(
                        'assets/image/splash.svg',
                        width: MediaQuery.of(context).size.width * 0.65,
                        fit: BoxFit.contain,
                        placeholderBuilder: (_) =>
                            const SizedBox(width: 260, height: 260),
                      ),
                    ),
                  ),
                ),
              ),
      
              // ── CTA block ─────────────────────────────────────
              FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slideButton,
                  child: _isCheckingSession
                      ? SizedBox(
                          height: 52,
                          child: Center(
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.6,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            PrimaryButton(
                              label: 'Get Started',
                              onTap: () {
                                context.push(AppRoutes.auth);
                              },
                              width: double.infinity,
                              textColor: AppColor.white,
                              borderRadius: AppSizes.r12,
                              backgroundColor: AppColor.primary,
                              icon: HugeIconsSolid.arrowRight02,
                              iconTrailing: true,
                            ),
                            SizedBox(height: AppSizes.s16),
                            TextButton(
                              onPressed: () {
                                // TODO: navigate to login (forgot/login link)
                              },
                              child: Text(
                                'Already have an account? Log in',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
      
              SizedBox(height: AppSizes.s32),
            ],
          ),
        ),
      ),
    );
  }
}
