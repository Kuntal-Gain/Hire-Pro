// ignore_for_file: constant_identifier_names

class ApplicantProfileRequestModel {
  final String? userId;
  final PersonalDetailsRequestModel? personalDetails;
  final AcademicDetailsRequestModel? academicDetails;
  final ProfessionalDetailsRequestModel? professionalDetails;
  final JobPreferencesRequestModel? jobPreferences;

  ApplicantProfileRequestModel({
    required this.userId,
    required this.personalDetails,
    required this.academicDetails,
    required this.professionalDetails,
    required this.jobPreferences,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "personal": personalDetails?.toJson() ?? {},
      "education": academicDetails?.toJson() ?? {},
      "professional": professionalDetails?.toJson() ?? {},
      "preferences": jobPreferences?.toJson() ?? {},
    };
  }
}

class EmployerProfileRequestModel {
  final String? userId;
  final PersonalDetailsRequestModel? personal;
  final ProfessionalDetailsRequestModel? professional;
  final String companyId;

  EmployerProfileRequestModel({
    required this.userId,
    required this.personal,
    required this.professional,
    required this.companyId,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "personal": personal?.toJson() ?? {},
      "professional": professional?.toJson() ?? {},
      "company_id": companyId,
    };
  }
}

/// —————————————————————————————————————————————————————
///         [PERSONAL DETAILS REQUEST MODEL]
/// —————————————————————————————————————————————————————

class PersonalDetailsRequestModel {
  final String? fullName;
  final String? profileImage;
  final String? headline;
  final String? bio;
  final String? phone;
  final String? email;
  final String? gender;
  final DateTime? dateOfBirth;
  final LocationRequestModel? location;
  final String? portfolio;
  final String? linkedin;
  final String? github;
  final String? website;

  PersonalDetailsRequestModel({
    required this.fullName,
    required this.profileImage,
    required this.headline,
    required this.bio,
    required this.phone,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.location,
    required this.portfolio,
    required this.linkedin,
    required this.github,
    required this.website,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "profileImage": profileImage,
      "headline": headline,
      "bio": bio,
      "phone": phone,
      "email": email,
      "gender": gender,
      "dateOfBirth": dateOfBirth?.toIso8601String(),
      "location": location?.toJson(),
      "portfolio": portfolio,
      "linkedin": linkedin,
      "github": github,
      "website": website,
    };
  }
}

class LocationRequestModel {
  final String? city;
  final String? state;
  final String? country;

  LocationRequestModel({this.city, this.state, this.country});

  Map<String, dynamic> toJson() {
    return {"city": city, "state": state, "country": country};
  }
}

/// —————————————————————————————————————————————————————
///         [ACADEMIC DETAILS REQUEST MODEL]
/// —————————————————————————————————————————————————————

class AcademicDetailsRequestModel {
  final List<AcademicHistoryItem> education;
  final List<CertificationItem> certifications;

  AcademicDetailsRequestModel({
    required this.education,
    required this.certifications,
  });

  Map<String, dynamic> toJson() {
    return {
      "education": education.map((item) => item.toJson()).toList(),
      "certifications": certifications.map((item) => item.toJson()).toList(),
    };
  }
}

class AcademicHistoryItem {
  final DegreeType degree;
  final SpecializationType specialization;
  final String institution;
  final String boardOrUniversity;
  final int startYear;
  final int endYear;
  final GradeType grade;
  final String gradeType;

  AcademicHistoryItem({
    required this.degree,
    required this.specialization,
    required this.institution,
    required this.boardOrUniversity,
    required this.startYear,
    required this.endYear,
    required this.grade,
    required this.gradeType,
  });

  Map<String, dynamic> toJson() {
    return {
      "degree": degree.label,
      "specialization": specialization.label,
      "institution": institution,
      "boardOrUniversity": boardOrUniversity,
      "startYear": startYear,
      "endYear": endYear,
      "grade": grade.name,
      "gradeType": gradeType,
    };
  }
}

class CertificationItem {
  final String name;
  final String issuingOrganization;
  final DateTime issueDate;
  final DateTime? expirationDate;
  final String credentialId;
  final String credentialUrl;

  CertificationItem({
    required this.name,
    required this.issuingOrganization,
    required this.issueDate,
    this.expirationDate,
    required this.credentialId,
    required this.credentialUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "issuingOrganization": issuingOrganization,
      "issueDate": issueDate.toIso8601String(),
      "expirationDate": expirationDate?.toIso8601String(),
      "credentialId": credentialId,
      "credentialUrl": credentialUrl,
    };
  }
}

/// —————————————————————————————————————————————————————
///         [PROFESSIONAL DETAILS REQUEST MODEL]
/// —————————————————————————————————————————————————————

class ProfessionalDetailsRequestModel {
  final num totalExperience;
  final List<SkillItem> skills;
  final List<WorkHistoryItem> workHistory;
  final List<ProjectItem> projects;
  final ResumeItem? resume;

  ProfessionalDetailsRequestModel({
    required this.totalExperience,
    required this.skills,
    required this.workHistory,
    required this.projects,
    required this.resume,
  });

  Map<String, dynamic> toJson() {
    return {
      "totalExperience": totalExperience,
      "skills": skills.map((item) => item.toJson()).toList(),
      "workHistory": workHistory.map((item) => item.toJson()).toList(),
      "projects": projects.map((item) => item.toJson()).toList(),
      "resume": resume?.toJson() ?? {},
    };
  }
}

class SkillItem {
  final String name;
  final num yearsOfExperience;

  SkillItem({required this.name, required this.yearsOfExperience});

  Map<String, dynamic> toJson() {
    return {"name": name, "yearsOfExperience": yearsOfExperience};
  }
}

class WorkHistoryItem {
  final String? companyId;
  final String? companyName;
  final String? designation;
  final String? employmentType;
  final String? workMode;
  final String? location;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? currentlyWorking;
  final String? description;

  WorkHistoryItem({
    required this.companyId,
    required this.companyName,
    required this.designation,
    required this.employmentType,
    required this.workMode,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.currentlyWorking,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "companyId": companyId ?? "",
      "companyName": companyName ?? "",
      "designation": designation ?? "",
      "employmentType": employmentType ?? "",
      "workMode": workMode ?? "",
      "location": location ?? "",
      "startDate": startDate?.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
      "currentlyWorking": currentlyWorking,
      "description": description ?? "",
    };
  }
}

class ProjectItem {
  final String? title;
  final String? description;
  final List<String>? technologies;
  final String? projectUrl;
  final String? githubUrl;

  ProjectItem({
    required this.title,
    required this.description,
    required this.technologies,
    required this.projectUrl,
    required this.githubUrl,
  });
  Map<String, dynamic> toJson() {
    return {
      "title": title ?? "",
      "description": description ?? "",
      "technologies": technologies ?? [],
      "projectUrl": projectUrl ?? "",
      "githubUrl": githubUrl ?? "",
    };
  }
}

class ResumeItem {
  final String? name;
  final String? url;
  final DateTime? uploadedAt;

  ResumeItem({required this.name, required this.url, required this.uploadedAt});

  Map<String, dynamic> toJson() {
    return {
      "name": name ?? "",
      "url": url ?? "",
      "uploadedAt": uploadedAt?.toIso8601String(),
    };
  }
}

/// —————————————————————————————————————————————————————
///         [JOB PREFERENCES REQUEST MODEL]
/// —————————————————————————————————————————————————————

class JobPreferencesRequestModel {
  final List<String>? preferredJobTitles;
  final List<String>? employmentTypes;
  final List<String>? workModes;
  final List<String>? preferredLocations;
  final ExpectedSalaryRequestModel? expectedSalary;
  final int noticePeriodInDays;
  final bool openToRelocation;
  final List<String>? preferredIndustries;
  final List<String>? preferredDepartments;

  JobPreferencesRequestModel({
    required this.preferredJobTitles,
    required this.employmentTypes,
    required this.workModes,
    required this.preferredLocations,
    required this.expectedSalary,
    required this.noticePeriodInDays,
    required this.openToRelocation,
    required this.preferredIndustries,
    required this.preferredDepartments,
  });

  Map<String, dynamic> toJson() {
    return {
      "preferredJobTitles": preferredJobTitles ?? [],
      "employmentTypes": employmentTypes ?? [],
      "workModes": workModes ?? [],
      "preferredLocations": preferredLocations ?? [],
      "expectedSalary": expectedSalary?.toJson(),
      "noticePeriodInDays": noticePeriodInDays,
      "openToRelocation": openToRelocation,
      "preferredIndustries": preferredIndustries ?? [],
      "preferredDepartments": preferredDepartments ?? [],
    };
  }
}

class ExpectedSalaryRequestModel {
  final num? minSalary;
  final num? maxSalary;
  final CurrencyType? currency;

  ExpectedSalaryRequestModel({
    required this.minSalary,
    required this.maxSalary,
    required this.currency,
  });

  Map<String, dynamic> toJson() {
    return {
      "minSalary": minSalary,
      "maxSalary": maxSalary,
      "currency": currency?.name,
    };
  }
}

/// ——————————————————— helpers ———————————————————

enum GenderType { MALE, FEMALE, OTHER }

enum DegreeType {
  BTECH,
  BSC,
  BA,
  BCOM,
  BCA,
  BBA,
  MSC,
  MA,
  MCOM,
  MCA,
  MBA,
  OTHER,
}

enum SpecializationType {
  COMPUTER_SCIENCE,
  ELECTRICAL_ENGINEERING,
  MECHANICAL_ENGINEERING,
  CIVIL_ENGINEERING,
  INFORMATION_TECHNOLOGY,
  ELECTRONICS_AND_COMMUNICATION,
  OTHER,
}

enum GradeType { CGPA, Percentage, Marks, Other }

enum EmploymentType {
  FULL_TIME,
  PART_TIME,
  CONTRACT,
  TEMPORARY,
  INTERN,
  VOLUNTEER,
  OTHER,
}

enum WorkMode { ONSITE, REMOTE, HYBRID, OTHER }

enum CurrencyType { USD, EUR, JPY, INR, OTHER }

extension DegreeTypeExtension on DegreeType {
  String get label {
    switch (this) {
      case DegreeType.BTECH:
        return "B.Tech";
      case DegreeType.BSC:
        return "B.Sc";
      case DegreeType.BA:
        return "B.A";
      case DegreeType.BCOM:
        return "B.Com";
      case DegreeType.BCA:
        return "BCA";
      case DegreeType.BBA:
        return "BBA";
      case DegreeType.MSC:
        return "M.Sc";
      case DegreeType.MA:
        return "M.A";
      case DegreeType.MCOM:
        return "M.Com";
      case DegreeType.MCA:
        return "MCA";
      case DegreeType.MBA:
        return "MBA";
      case DegreeType.OTHER:
        return "Other";
    }
  }
}

extension SpecializationTypeExtension on SpecializationType {
  String get label {
    switch (this) {
      case SpecializationType.COMPUTER_SCIENCE:
        return "Computer Science";
      case SpecializationType.ELECTRICAL_ENGINEERING:
        return "Electrical Engineering";
      case SpecializationType.MECHANICAL_ENGINEERING:
        return "Mechanical Engineering";
      case SpecializationType.CIVIL_ENGINEERING:
        return "Civil Engineering";
      case SpecializationType.INFORMATION_TECHNOLOGY:
        return "Information Technology";
      case SpecializationType.ELECTRONICS_AND_COMMUNICATION:
        return "Electronics & Communication";
      default:
        return "Other";
    }
  }
}

extension EmploymentTypeExtension on EmploymentType {
  String get label {
    switch (this) {
      case EmploymentType.FULL_TIME:
        return "Full Time";
      case EmploymentType.PART_TIME:
        return "Part Time";
      case EmploymentType.CONTRACT:
        return "Contract";
      case EmploymentType.TEMPORARY:
        return "Temporary";
      case EmploymentType.INTERN:
        return "Intern";
      case EmploymentType.VOLUNTEER:
        return "Volunteer";
      default:
        return "Other";
    }
  }
}

extension WorkModeExtension on WorkMode {
  String get label {
    switch (this) {
      case WorkMode.ONSITE:
        return "On-site";
      case WorkMode.REMOTE:
        return "Remote";
      case WorkMode.HYBRID:
        return "Hybrid";
      default:
        return "Other";
    }
  }
}
