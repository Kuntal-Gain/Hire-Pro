import 'package:hire_pro/core/network/resource.dart';
import 'package:hire_pro/features/auth/model/user_model.dart';
import 'package:hire_pro/features/auth/model/user_request_model.dart';

abstract class AuthUsecase {
  /// supbase authentications
  
  Future<Resource<void>> signup(String email , String password);
  Future<Resource<void>> login(String email , String password);
  Future<Resource<String>> getCurrentUid();
  Future<Resource<void>> isLoggedIn();
  Future<Resource<void>> logout();

  Future<Resource<void>> createUser(UserRequestModel user);
  Future<Resource<UserModel>> getCurrentUser();
}