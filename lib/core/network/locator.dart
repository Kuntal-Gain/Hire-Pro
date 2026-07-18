/*

final demoServiceProvider = Provider<DemoServiceUsecase>((ref) => DemoServiceUsecaseImpl());

*/

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hire_pro/features/auth/data/auth_usecase.dart';
import 'package:hire_pro/features/auth/data/auth_usecase_impl.dart';
import 'package:hire_pro/features/profile/data/profile_usecase.dart';
import 'package:hire_pro/features/profile/data/profile_usecase_impl.dart';

final authServiceProvider = Provider<AuthUsecase>((ref) => AuthUsecaseImpl());

final profileServiceProvider = Provider<ProfileUsecase>(
  (ref) => ProfileUsecaseImpl(),
);