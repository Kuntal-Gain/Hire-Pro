import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hire_pro/app.dart';
import 'package:hire_pro/app/env.dart';
import 'package:hire_pro/core/network/client_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Env.initialize();
  await SupabaseConfig.initialize();

  runApp(ProviderScope(child: const HireProApp()));
}

