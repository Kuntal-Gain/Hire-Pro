import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hire_pro/core/extensions/resource_extension.dart';
import 'package:hire_pro/core/network/locator.dart';
import 'package:hire_pro/features/auth/model/user_model.dart';
import 'package:hire_pro/features/auth/model/user_request_model.dart';

class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    final uc = ref.read(authServiceProvider);
    final user = (await uc.getCurrentUser()).unwrap();

    if (user != null) {
      final storage = ref.read(localStorageServiceProvider);
      await storage.setUserId(user.uid);
      await storage.setUserType(user.usertype.name);
    }

    return user;
  }

  Future<void> login({required String email, required String password}) async {
    final uc = ref.read(authServiceProvider);

    (await uc.login(email, password)).unwrap();

    ref.invalidateSelf();
    await future;
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    final uc = ref.read(authServiceProvider);

    (await uc.signup(email, password)).unwrap();
  }

  Future<void> createUser({required UserRequestModel user}) async {
    final uc = ref.read(authServiceProvider);

    (await uc.createUser(user)).unwrap();

    ref.invalidateSelf();
    await future;
  }

  Future<void> logout() async {
    final uc = ref.read(authServiceProvider);

    (await uc.logout()).unwrap();

    await ref.read(localStorageServiceProvider).clear();

    state = const AsyncData(null);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final authProvider =
    AsyncNotifierProvider<AuthNotifier, UserModel?>(AuthNotifier.new);