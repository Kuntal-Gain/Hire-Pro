import 'package:hire_pro/core/network/resource.dart';

extension ResourceX<T> on Resource<T> {
  T? unwrap() {
    switch (this) {
      case Success(data: final data):
        return data;

      case Error(failure: final failure):
        throw failure;
    }
  }
}
