

import '../../../core/utils/enums.dart';

class UserRequestModel {
  final String uid;
  final String email;
  final UserType type;

  UserRequestModel({
    required this.uid,
    required this.email,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'type': type.name,
    };
  }
}
