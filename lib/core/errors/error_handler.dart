import 'dart:io';

import 'package:hire_pro/core/errors/exceptions.dart';
import 'package:hire_pro/core/errors/failures.dart';

final class ErrorHandler {
  const ErrorHandler._();

  static Failure handle(Object error) {
    switch (error) {
      case ServerException():
        return ServerFailure(error.message);
      case AuthException():
        return AuthFailure(error.message);
      case StorageException():
        return StorageFailure(error.message);
      case CacheException():
        return UnexpectedFailure(error.message);
      case SocketException():
        return const NetworkFailure();
      case HttpException():
        return const ServerFailure();
      default:
        return UnexpectedFailure(error.toString());
    }
  }
}
