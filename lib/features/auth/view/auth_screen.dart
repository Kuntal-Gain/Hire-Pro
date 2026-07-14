import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hire_pro/core/constants/color_constants.dart';
import 'package:hire_pro/core/constants/sizes_constants.dart';
import 'package:hire_pro/core/extensions/size_extension.dart';
import 'package:hire_pro/core/network/client_manager.dart';
import 'package:hire_pro/core/router/app_routes.dart';
import 'package:hire_pro/core/utils/enums.dart';
import 'package:hire_pro/features/auth/model/user_request_model.dart';
import 'package:hire_pro/features/auth/provider/auth_provider.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:hire_pro/shared/widgets/buttons/primary_button.dart';

enum AuthMode { login, signup }


class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with TickerProviderStateMixin {
  AuthMode _mode = AuthMode.login;
  UserType _role = UserType.applicant;

  late final AnimationController _flipController;
  late final AnimationController _switchController;

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _switchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..value = 1;
  }

  @override
  void dispose() {
    _flipController.dispose();
    _switchController.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _mode = _mode == AuthMode.login ? AuthMode.signup : AuthMode.login;
      _formKey.currentState?.reset();
    });
    _switchController.forward(from: 0);
  }

  Future<void> _toggleRole() async {
    // Flip out
    await _flipController.forward();
    setState(() {
      _role = _role == UserType.applicant
          ? UserType.recruiter
          : UserType.applicant;
      _mode = AuthMode.login;
    });
    // Flip in
    await _flipController.reverse();
  }

  void _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => isLoading = true);

    try {
      if (_mode == AuthMode.signup) {
        await ref
            .read(authProvider.notifier)
            .register(email: _emailCtrl.text, password: _passCtrl.text);

        await ref
            .read(authProvider.notifier)
            .createUser(
              user: UserRequestModel(
                uid: SupabaseManager.currentUserId ?? "",
                email: _emailCtrl.text,
                type: _role,
              ),
            );
      } else {
        await ref
            .read(authProvider.notifier)
            .login(email: _emailCtrl.text, password: _passCtrl.text);
      }

      if (!context.mounted) return;

      FocusScope.of(context).unfocus();

      // Navigate after successful login/signup
      // ignore: use_build_context_synchronously
      context.push(AppRoutes.home);
      // or:
      // context.go('/home'); // if using go_router
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (context.mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  bool get _isEmployer => _role == UserType.recruiter;
  bool get _isSignup => _mode == AuthMode.signup;

  @override
  Widget build(BuildContext context) {
    final accent = _isEmployer ? AppColor.secondary : AppColor.primary;

    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSizes.s24),
              _buildHeader(accent),
              SizedBox(height: AppSizes.s32),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.05),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: _buildForm(accent),
              ),
              SizedBox(height: AppSizes.s24),
              _buildModeToggle(accent),
              SizedBox(height: AppSizes.s32),
              _buildRoleFlipButton(accent),
              SizedBox(height: AppSizes.s24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color accent) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: Column(
        key: ValueKey(_role),
        children: [
          Container(
            width: context.widthFraction(.18),
            height: context.widthFraction(.18),
            decoration: BoxDecoration(
              gradient: _isEmployer
                  ? AppColor.primaryGradient
                  : AppColor.primaryGradient,
              borderRadius: BorderRadius.circular(AppSizes.r20),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.28),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              _isEmployer ? Icons.apartment_rounded : Icons.person_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          SizedBox(height: AppSizes.s16),
          Text(
            _isSignup
                ? 'Create your ${_isEmployer ? 'employer' : ''} account'
                      .replaceAll('  ', ' ')
                : 'Welcome back',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColor.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: AppSizes.s8),
          Text(
            _isEmployer
                ? 'Hiring? Manage jobs and candidates.'
                : 'Find your next opportunity.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(Color accent) {
    return Form(
      key: _formKey,
      child: Column(
        key: ValueKey('${_mode}_$_role'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AuthField(
            controller: _emailCtrl,
            hint: 'Email address',
            icon: HugeIconsSolid.mail01,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          SizedBox(height: AppSizes.s16),
          _AuthField(
            controller: _passCtrl,
            hint: 'Password',
            icon: HugeIconsSolid.lockPassword,
            obscure: _obscure,
            suffixIcon: IconButton(
              icon: Icon(
                _obscure ? HugeIconsStroke.viewOff : HugeIconsStroke.view,
                size: 20,
                color: AppColor.textSecondary,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Required';
              if (v.length < 6) return 'Min 6 characters';
              return null;
            },
          ),
          if (!_isSignup) ...[
            SizedBox(height: AppSizes.s8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: forgot password flow
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
              ),
            ),
          ],
          SizedBox(height: AppSizes.s24),
          PrimaryButton(
            label: _isSignup ? 'Create account' : 'Log in',
            onTap: _submit,
            isLoading: isLoading,
            width: double.infinity,
            textColor: AppColor.white,
            borderRadius: AppSizes.r12,
            backgroundColor: accent,
            icon: HugeIconsSolid.arrowRight02,
            iconTrailing: true,
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggle(Color accent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isSignup ? 'Already have an account?' : "Don't have an account?",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColor.textSecondary,
          ),
        ),
        TextButton(
          onPressed: _toggleMode,
          child: Text(
            _isSignup ? 'Log in' : 'Sign up',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleFlipButton(Color accent) {
    return AnimatedBuilder(
      animation: _flipController,
      builder: (context, child) {
        final angle = _flipController.value * 3.14159; // 0 -> pi
        final showFront = _flipController.value < 0.5;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateX(angle),
          child: showFront
              ? child
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateX(3.14159),
                  child: child,
                ),
        );
      },
      child: InkWell(
        onTap: _toggleRole,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.s14,
            horizontal: AppSizes.s16,
          ),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(AppSizes.r12),
            border: Border.all(color: accent.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                HugeIconsSolid.arrowDataTransferHorizontal,
                size: 18,
                color: accent,
              ),
              SizedBox(width: AppSizes.s8),
              Text(
                _isEmployer
                    ? "I'm hiring... switch to applicant"
                    : "I'm an employer, switch account",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(fontSize: 14, color: AppColor.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14, color: AppColor.textSecondary),
        prefixIcon: Icon(icon, size: 20, color: AppColor.textSecondary),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColor.textSecondary.withValues(alpha: 0.06),
        contentPadding: EdgeInsets.symmetric(
          vertical: AppSizes.s14,
          horizontal: AppSizes.s16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(color: AppColor.primary, width: 1.5),
        ),
      ),
    );
  }
}
