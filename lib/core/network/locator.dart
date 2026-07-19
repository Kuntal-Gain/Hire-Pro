/*

final demoServiceProvider = Provider<DemoServiceUsecase>((ref) => DemoServiceUsecaseImpl());

*/

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hire_pro/core/storage/local_storage_service.dart';
import 'package:hire_pro/features/auth/data/auth_usecase.dart';
import 'package:hire_pro/features/auth/data/auth_usecase_impl.dart';
import 'package:hire_pro/features/profile/data/profile_usecase.dart';
import 'package:hire_pro/features/profile/data/profile_usecase_impl.dart';

final localStorageServiceProvider = Provider<LocalStorageService>(
  (ref) => LocalStorageService(),
);

final authServiceProvider = Provider<AuthUsecase>((ref) => AuthUsecaseImpl());

final profileServiceProvider = Provider<ProfileUsecase>(
  (ref) => ProfileUsecaseImpl(),
);