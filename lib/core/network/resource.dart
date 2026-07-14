import 'package:hire_pro/core/errors/error_handler.dart';
import 'package:hire_pro/core/errors/failures.dart';

sealed class Resource<T> {
  const Resource();

  factory Resource.success([T? data]) = Success<T>;

  factory Resource.failure(Object error) =>
      Error<T>(ErrorHandler.handle(error));
}

final class Success<T> extends Resource<T> {
  final T? data;

  const Success([this.data]);
}

final class Error<T> extends Resource<T> {
  final Failure failure;

  const Error(this.failure);
}
