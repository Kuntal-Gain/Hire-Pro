import 'package:flutter/material.dart';
import 'package:hire_pro/app/theme/theme.dart';
import 'package:hire_pro/core/router/app_router.dart';

class HireProApp extends StatelessWidget {
  const HireProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,

      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
    );
  }
}
