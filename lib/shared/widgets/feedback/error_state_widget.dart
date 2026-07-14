// i

// // ── Error variant descriptor ──────────────────────────────────────────────────

// class _ErrorVariant {
//   final IconData icon;
//   final Color color;
//   final String title;
//   final String subtitle;
//   final String? hint;
//   final bool showRetry;
//   final bool showLogin;

//   const _ErrorVariant({
//     required this.icon,
//     required this.color,
//     required this.title,
//     required this.subtitle,
//     this.hint,
//     this.showRetry = false,
//     this.showLogin = false,
//   });
// }

// _ErrorVariant _variantFor(Object error) {
//   if (error is ServerFailure) {
//     switch (error.statusCode) {
//       case 400:
//         return const _ErrorVariant(
//           icon: Icons.error_outline_rounded,
//           color: Color(0xFFF59E0B),
//           title: 'Bad Request',
//           subtitle: 'The request could not be understood by the server.',
//           hint: 'Check your input and try again.',
//           showRetry: true,
//         );
//       case 403:
//         return const _ErrorVariant(
//           icon: Icons.lock_rounded,
//           color: Color(0xFFEF4444),
//           title: 'Access Denied',
//           subtitle: 'You don\'t have permission\nto view this content.',
//           hint: 'Contact your administrator for access.',
//         );
//       case 409:
//         return const _ErrorVariant(
//           icon: Icons.sync_problem_rounded,
//           color: Color(0xFF8B5CF6),
//           title: 'Conflict',
//           subtitle: 'This request conflicts\nwith existing data.',
//           hint: 'Please refresh and try again.',
//           showRetry: true,
//         );
//       case final c when c != null && c >= 500:
//         return const _ErrorVariant(
//           icon: Icons.dns_rounded,
//           color: Color(0xFFEF4444),
//           title: 'Server Error',
//           subtitle: 'Something went wrong\non our end.',
//           hint: 'We\'re working on it. Please try again later.',
//           showRetry: true,
//         );
//     }
//   }

//   if (error is UnauthorizedFailure) {
//     return const _ErrorVariant(
//       icon: Icons.person_off_rounded,
//       color: Color(0xFFF59E0B),
//       title: 'Session Expired',
//       subtitle: 'Your session has expired.\nPlease log in again.',
//       showLogin: true,
//     );
//   }

//   if (error is NotFoundFailure) {
//     return const _ErrorVariant(
//       icon: Icons.search_off_rounded,
//       color: Color(0xFF6B7280),
//       title: 'Not Found',
//       subtitle: 'The resource you\'re looking\nfor doesn\'t exist.',
//       hint: 'It may have been moved or deleted.',
//     );
//   }

//   if (error is NetworkFailure) {
//     return const _ErrorVariant(
//       icon: Icons.wifi_off_rounded,
//       color: Color(0xFF6B7280),
//       title: 'No Connection',
//       subtitle: 'Unable to reach the server.\nCheck your internet connection.',
//       showRetry: true,
//     );
//   }

//   // Default
//   return const _ErrorVariant(
//     icon: Icons.warning_amber_rounded,
//     color: Color(0xFF6B7280),
//     title: 'Something Went Wrong',
//     subtitle: 'An unexpected error occurred.\nPlease try again.',
//     showRetry: true,
//   );
// }

// // ── ErrorView ─────────────────────────────────────────────────────────────────

// /// Production-safe error view — never crashes the UI.
// /// Automatically resolves the correct variant based on the Failure type.
// class ErrorView extends StatelessWidget {
//   final Object error;
//   final VoidCallback? onRetry;
//   final bool compact;

//   const ErrorView({
//     super.key,
//     required this.error,
//     this.onRetry,
//     this.compact = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final v = _variantFor(error);

//     if (compact) {
//       return Row(
//         children: [
//           Icon(v.icon, color: v.color, size: 16),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               v.title,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: v.color,
//                 fontFamily: AppTypography.fontFamily,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       );
//     }

//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
//           decoration: BoxDecoration(
//             color: AppColors.bgCard,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: v.color.withValues(alpha: 0.18)),
//             boxShadow: [
//               BoxShadow(
//                 color: v.color.withValues(alpha: 0.07),
//                 blurRadius: 24,
//                 offset: const Offset(0, 8),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // ── Icon box ────────────────────────────────────────────
//               Container(
//                 width: 72,
//                 height: 72,
//                 decoration: BoxDecoration(
//                   color: v.color.withValues(alpha: 0.08),
//                   borderRadius: BorderRadius.circular(18),
//                   border: Border.all(color: v.color.withValues(alpha: 0.20)),
//                 ),
//                 child: Icon(v.icon, size: 34, color: v.color),
//               ),
//               const SizedBox(height: 20),

//               // ── Title ───────────────────────────────────────────────
//               Text(
//                 v.title,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: AppColors.textColor,
//                   fontFamily: AppTypography.fontFamily,
//                 ),
//               ),
//               const SizedBox(height: 8),

//               // ── Subtitle ────────────────────────────────────────────
//               Text(
//                 v.subtitle,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   color: AppColors.captionColor,
//                   fontFamily: AppTypography.fontFamily,
//                   height: 1.6,
//                 ),
//               ),

//               // ── Hint pill ───────────────────────────────────────────
//               if (v.hint != null) ...[
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 14,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: v.color.withValues(alpha: 0.06),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.info_outline_rounded,
//                         size: 12,
//                         color: v.color,
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         v.hint!,
//                         style: TextStyle(
//                           fontSize: 11,
//                           color: v.color,
//                           fontFamily: AppTypography.fontFamily,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],

//               // ── CTAs ────────────────────────────────────────────────
//               if (v.showRetry && onRetry != null) ...[
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     onPressed: onRetry,
//                     icon: const Icon(Icons.refresh_rounded, size: 16),
//                     label: const Text('Try Again'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: v.color,
//                       foregroundColor: Colors.white,
//                       elevation: 0,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       textStyle: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         fontFamily: AppTypography.fontFamily,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],

//               if (v.showLogin) ...[
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     onPressed: () => GoRouter.of(context).go('/login'),
//                     icon: const Icon(Icons.login_rounded, size: 16),
//                     label: const Text('Log In Again'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFF59E0B),
//                       foregroundColor: Colors.white,
//                       elevation: 0,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       textStyle: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         fontFamily: AppTypography.fontFamily,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ErrorBanner extends StatelessWidget {
//   final String message;

//   const ErrorBanner({required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//       decoration: BoxDecoration(
//         color: AppColors.error.withValues(alpha: 0.07),
//         borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
//         border: Border.all(color: AppColors.error.withValues(alpha: 0.22)),
//       ),
//       child: Row(
//         children: [
//           const Icon(
//             Icons.error_outline_rounded,
//             color: AppColors.error,
//             size: 18,
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               message,
//               style: const TextStyle(
//                 color: AppColors.error,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: AppTypography.fontFamily,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ————————————————————————————————————————————————————————————————————————————
// // Common Error Screen
// // ————————————————————————————————————————————————————————————————————————————

// class CommonErrorScreen extends StatelessWidget {
//   final String title;
//   final String message;
//   final String? note;
//   final String buttonText;
//   final VoidCallback? onButtonPressed;
//   final Color color;
//   final IconData icon;
//   final String screenName;

//   const CommonErrorScreen({
//     super.key,
//     required this.title,
//     required this.message,
//     this.note,
//     this.buttonText = 'Try Again',
//     this.onButtonPressed,
//     this.color = AppColors.error,
//     this.icon = AppIcons.error,
//     this.screenName = '',
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgPage,
//       body: Column(
//         children: [
//           /// App Bar
//           CommonAppBar(title: screenName),

//           /// Content
//           Expanded(
//             child: Center(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(32),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: 96,
//                       height: 96,
//                       decoration: BoxDecoration(
//                         color: color.withValues(alpha: 0.12),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(icon, color: color, size: 52),
//                     ),

//                     const SizedBox(height: 24),

//                     Text(
//                       title,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.textColor,
//                         fontFamily: AppTypography.fontFamily,
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     Text(
//                       message,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: AppColors.captionColor,
//                         fontFamily: AppTypography.fontFamily,
//                         height: 1.6,
//                       ),
//                     ),

//                     if (note != null) ...[
//                       const SizedBox(height: 10),

//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 10,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppColors.grey100,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(
//                           note!,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: AppColors.captionColor,
//                             fontFamily: AppTypography.fontFamily,
//                           ),
//                         ),
//                       ),
//                     ],

//                     SizedBox(
//                       height: AppSizes.screenHeightFraction(context, 0.1),
//                     ),

//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed:
//                             onButtonPressed ?? () => GoRouter.of(context).pop(),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: color,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                         ),
//                         child: Text(
//                           buttonText,
//                           style: const TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w700,
//                             fontFamily: AppTypography.fontFamily,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:hire_pro/core/constants/color_constants.dart';
import 'package:hire_pro/core/errors/failures.dart';

class _ErrorVariant {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String? hint;
  final bool showRetry;
  final bool showLogin;

  const _ErrorVariant({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.hint,
    this.showRetry = false,
    this.showLogin = false,
  });
}

_ErrorVariant _variantFor(Object error) {
  // AuthFailure covers both "wrong credentials" and "session expired" —
  // distinguish by message content since that's what ErrorHandler sets.
  if (error is AuthFailure) {
    final expired = error.message.toLowerCase().contains('expired');
    return _ErrorVariant(
      icon: expired ? Icons.person_off_rounded : Icons.lock_rounded,
      color: AppColor.warning,
      title: expired ? 'Session Expired' : 'Authentication Failed',
      subtitle: error.message,
      showLogin: expired,
      showRetry: !expired,
    );
  }

  if (error is NotFoundFailure) {
    return _ErrorVariant(
      icon: Icons.search_off_rounded,
      color: AppColor.textSecondary,
      title: 'Not Found',
      subtitle: error.message,
      hint: 'It may have been moved or deleted.',
    );
  }

  if (error is NetworkFailure) {
    return _ErrorVariant(
      icon: Icons.wifi_off_rounded,
      color: AppColor.textSecondary,
      title: 'No Connection',
      subtitle: error.message,
      showRetry: true,
    );
  }

  if (error is ValidationFailure) {
    return _ErrorVariant(
      icon: Icons.error_outline_rounded,
      color: AppColor.warning,
      title: 'Invalid Input',
      subtitle: error.message,
    );
  }

  if (error is StorageFailure) {
    return _ErrorVariant(
      icon: Icons.cloud_off_rounded,
      color: AppColor.error,
      title: 'Upload Failed',
      subtitle: error.message,
      showRetry: true,
    );
  }

  if (error is ServerFailure) {
    final code = error.statusCode;
    if (code == 409) {
      return _ErrorVariant(
        icon: Icons.sync_problem_rounded,
        color: AppColor.error,
        title: 'Conflict',
        subtitle: 'This request conflicts with existing data.',
        hint: 'Please refresh and try again.',
        showRetry: true,
      );
    }
    if (code != null && code >= 500) {
      return _ErrorVariant(
        icon: Icons.dns_rounded,
        color: AppColor.error,
        title: 'Server Error',
        subtitle: 'Something went wrong on our end.',
        hint: 'We\'re working on it. Please try again later.',
        showRetry: true,
      );
    }
    return _ErrorVariant(
      icon: Icons.error_outline_rounded,
      color: AppColor.warning,
      title: 'Something Went Wrong',
      subtitle: error.message,
      showRetry: true,
    );
  }

  // UnexpectedFailure + any non-Failure object
  return const _ErrorVariant(
    icon: Icons.warning_amber_rounded,
    color: Color(0xFF6B7280),
    title: 'Something Went Wrong',
    subtitle: 'An unexpected error occurred.\nPlease try again.',
    showRetry: true,
  );
}
