/// A collection for centralized enums

/// [UserType]
enum UserType { applicant, recruiter }

extension UserTypeX on UserType {
  static UserType fromString(String value) {
    return UserType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UserType.applicant,
    );
  }
}
