import 'package:hire_pro/core/constants/server_constants.dart';
import 'package:hire_pro/core/network/client_manager.dart';
import 'package:hire_pro/core/network/resource.dart';
import 'package:hire_pro/features/auth/data/auth_usecase.dart';
import 'package:hire_pro/features/auth/model/user_model.dart';
import 'package:hire_pro/features/auth/model/user_request_model.dart';

class AuthUsecaseImpl implements AuthUsecase {
  final auth = SupabaseManager.auth;

  @override
  Future<Resource<bool>> isLoggedIn() async {
    return Resource.success(auth.currentSession != null);
  }

  @override
  Future<Resource<void>> login(String email, String password) async {
    try {
      await auth.signInWithPassword(email: email, password: password);

      return  Resource.success();
    } catch (e) {
      return Resource.failure(e);
    }
  }

  @override
  Future<Resource<void>> signup(String email, String password) async {
    try {
      await auth.signUp(email: email, password: password);

      return  Resource.success();
    } catch (e) {
      return Resource.failure(e);
    }
  }

  @override
  Future<Resource<String>> getCurrentUid() async {
    return Resource.success(auth.currentUser?.id ?? '');
  }

  @override
  Future<Resource<void>> createUser(UserRequestModel user) async {
    try {
      await SupabaseManager.from(Tables.users).insert(user.toJson());

      return  Resource.success();
    } catch (e) {
      return Resource.failure(e);
    }
  }

  @override
  Future<Resource<UserModel>> getCurrentUser() async {
    try {
      final json = await SupabaseManager.from(
        Tables.users,
      ).select().eq('id', SupabaseManager.currentUserId!).single();

      return Resource.success(UserModel.fromJson(json));
    } catch (e) {
      return Resource.failure(e);
    }
  }
  
  @override
  Future<Resource<void>> logout() async{
    try {
      await auth.signOut();

      return Resource.success();
    } catch (e) {
      throw Resource.failure(e);
    }
  }
}
