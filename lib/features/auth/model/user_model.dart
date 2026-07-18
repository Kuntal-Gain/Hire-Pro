import '../../../core/utils/enums.dart';

class UserModel {
  final String uid;
  final String email;
  final UserType usertype;
  final bool isProfileCreated;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.usertype,
    required this.isProfileCreated,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      usertype: UserTypeX.fromString(json['user_type']),
      isProfileCreated: json['is_profile_created'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
