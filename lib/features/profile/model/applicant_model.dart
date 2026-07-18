class ApplicantProfileModel {
  final String? id;
  final String? userId;
  final PersonalDetailsModel personalDetails;
  final AcademicDetailsModel academicDetails;
  final ProfessionalDetailsModel professionalDetails;
  final JobPreferencesModel jobPreferences;
  final ProfileMetaModel? profileMeta;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ApplicantProfileModel({
    required this.id,
    required this.userId,
    required this.personalDetails,
    required this.academicDetails,
    required this.professionalDetails,
    required this.jobPreferences,
    required this.profileMeta,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ApplicantProfileModel.fromJson(Map<String, dynamic> json) {
    return ApplicantProfileModel(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString(),
      personalDetails: PersonalDetailsModel.fromJson(json['personal'] ?? {}),
      academicDetails: AcademicDetailsModel.fromJson(json['education'] ?? {}),
      professionalDetails: ProfessionalDetailsModel.fromJson(
        json['professional'] ?? {},
      ),
      jobPreferences: JobPreferencesModel.fromJson(json['preferences'] ?? {}),
      profileMeta: json['profile_meta'] != null
          ? ProfileMetaModel.fromJson(json['profile_meta'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}

/// —————————————————————————————————————————————————————
///         [PERSONAL DETAILS MODEL]
/// —————————————————————————————————————————————————————

class PersonalDetailsModel {
  final String? fullName;
  final String? profileImage;
  final String? headline;
  final String? bio;
  final String? phone;
  final String? email;
  final String? gender;
  final DateTime? dateOfBirth;
  final LocationModel? location;
  final String? portfolio;
  final String? linkedin;
  final String? github;
  final String? website;

  PersonalDetailsModel({
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

  factory PersonalDetailsModel.fromJson(Map<String, dynamic> json) {
    return PersonalDetailsModel(
      fullName: json['fullName'],
      profileImage: json['profileImage'],
      headline: json['headline'],
      bio: json['bio'],
      phone: json['phone'],
      email: json['email'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      portfolio: json['portfolio'],
      linkedin: json['linkedin'],
      github: json['github'],
      website: json['website'],
    );
  }
}

class LocationModel {
  final String? city;
  final String? state;
  final String? country;

  LocationModel({this.city, this.state, this.country});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      city: json['city'],
      state: json['state'],
      country: json['country'],
    );
  }
}

/// —————————————————————————————————————————————————————
///         [ACADEMIC DETAILS MODEL]
/// —————————————————————————————————————————————————————

class AcademicDetailsModel {
  final List<EducationModel> education;
  final List<CertificationModel> certifications;

  AcademicDetailsModel({required this.education, required this.certifications});

  factory AcademicDetailsModel.fromJson(Map<String, dynamic> json) {
    return AcademicDetailsModel(
      education: (json['education'] as List<dynamic>? ?? [])
          .map((item) => EducationModel.fromJson(item))
          .toList(),
      certifications: (json['certifications'] as List<dynamic>? ?? [])
          .map((item) => CertificationModel.fromJson(item))
          .toList(),
    );
  }
}

class EducationModel {
  final String? degree;
  final String? specialization;
  final String? institution;
  final String? boardOrUniversity;
  final int? startYear;
  final int? endYear;
  final String? grade;
  final String? gradeType;

  EducationModel({
    required this.degree,
    required this.specialization,
    required this.institution,
    required this.boardOrUniversity,
    required this.startYear,
    required this.endYear,
    required this.grade,
    required this.gradeType,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      degree: json['degree'],
      specialization: json['specialization'],
      institution: json['institution'],
      boardOrUniversity: json['boardOrUniversity'],
      startYear: json['startYear'],
      endYear: json['endYear'],
      grade: json['grade'],
      gradeType: json['gradeType'],
    );
  }
}

class CertificationModel {
  final String? title;
  final String? issuer;
  final DateTime? issueDate;
  final String? credentialId;
  final String? credentialUrl;

  CertificationModel({
    required this.title,
    required this.issuer,
    required this.issueDate,
    required this.credentialId,
    required this.credentialUrl,
  });

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      title: json['title'],
      issuer: json['issuer'],
      issueDate: json['issueDate'] != null
          ? DateTime.parse(json['issueDate'])
          : null,
      credentialId: json['credentialId'],
      credentialUrl: json['credentialUrl'],
    );
  }
}

/// —————————————————————————————————————————————————————
///         [PROFESSIONAL DETAILS MODEL]
/// —————————————————————————————————————————————————————

class ProfessionalDetailsModel {
  final num? totalExperience;
  final List<SkillModel> skills;
  final List<WorkHistoryModel> workHistory;
  final List<ProjectModel> projects;
  final ResumeModel? resume;

  ProfessionalDetailsModel({
    required this.totalExperience,
    required this.skills,
    required this.workHistory,
    required this.projects,
    required this.resume,
  });

  factory ProfessionalDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalDetailsModel(
      totalExperience: json['totalExperience'],
      skills: (json['skills'] as List<dynamic>? ?? [])
          .map((item) => SkillModel.fromJson(item))
          .toList(),
      workHistory: (json['workHistory'] as List<dynamic>? ?? [])
          .map((item) => WorkHistoryModel.fromJson(item))
          .toList(),
      projects: (json['projects'] as List<dynamic>? ?? [])
          .map((item) => ProjectModel.fromJson(item))
          .toList(),
      resume: json['resume'] != null
          ? ResumeModel.fromJson(json['resume'])
          : null,
    );
  }
}

class SkillModel {
  final String? name;
  final num? yearsOfExperience;

  SkillModel({required this.name, required this.yearsOfExperience});

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      name: json['name'],
      yearsOfExperience: json['yearsOfExperience'],
    );
  }
}

class WorkHistoryModel {
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

  WorkHistoryModel({
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

  factory WorkHistoryModel.fromJson(Map<String, dynamic> json) {
    return WorkHistoryModel(
      companyId: json['companyId'],
      companyName: json['companyName'],
      designation: json['designation'],
      employmentType: json['employmentType'],
      workMode: json['workMode'],
      location: json['location'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      currentlyWorking: json['currentlyWorking'],
      description: json['description'],
    );
  }
}

class ProjectModel {
  final String? title;
  final String? description;
  final List<String>? technologies;
  final String? projectUrl;
  final String? githubUrl;

  ProjectModel({
    required this.title,
    required this.description,
    required this.technologies,
    required this.projectUrl,
    required this.githubUrl,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      title: json['title'],
      description: json['description'],
      technologies: (json['technologies'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      projectUrl: json['projectUrl'],
      githubUrl: json['githubUrl'],
    );
  }
}

class ResumeModel {
  final String? name;
  final String? url;
  final DateTime? uploadedAt;

  ResumeModel({required this.name, required this.url, required this.uploadedAt});

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      name: json['name'],
      url: json['url'],
      uploadedAt: json['uploadedAt'] != null
          ? DateTime.parse(json['uploadedAt'])
          : null,
    );
  }
}

/// —————————————————————————————————————————————————————
///         [JOB PREFERENCES MODEL]
/// —————————————————————————————————————————————————————

class JobPreferencesModel {
  final List<String>? jobTitles;
  final List<String>? employmentTypes;
  final List<String>? workModes;
  final List<String>? preferredLocations;
  final ExpectedSalaryModel? expectedSalary;
  final int? noticePeriod;
  final bool? openToRelocate;
  final List<String>? preferredIndustries;
  final List<String>? preferredDepartments;

  JobPreferencesModel({
    required this.jobTitles,
    required this.employmentTypes,
    required this.workModes,
    required this.preferredLocations,
    required this.expectedSalary,
    required this.noticePeriod,
    required this.openToRelocate,
    required this.preferredIndustries,
    required this.preferredDepartments,
  });

  factory JobPreferencesModel.fromJson(Map<String, dynamic> json) {
    return JobPreferencesModel(
      jobTitles: (json['jobTitles'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      employmentTypes: (json['employmentTypes'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      workModes: (json['workModes'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      preferredLocations: (json['preferredLocations'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      expectedSalary: json['expectedSalary'] != null
          ? ExpectedSalaryModel.fromJson(json['expectedSalary'])
          : null,
      noticePeriod: json['noticePeriod'],
      openToRelocate: json['openToRelocate'],
      preferredIndustries: (json['preferredIndustries'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      preferredDepartments: (json['preferredDepartments'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}

class ExpectedSalaryModel {
  final String? currency;
  final num? minimum;
  final num? maximum;

  ExpectedSalaryModel({
    required this.currency,
    required this.minimum,
    required this.maximum,
  });

  factory ExpectedSalaryModel.fromJson(Map<String, dynamic> json) {
    return ExpectedSalaryModel(
      currency: json['currency'],
      minimum: json['minimum'],
      maximum: json['maximum'],
    );
  }
}

/// —————————————————————————————————————————————————————
///         [PROFILE META MODEL]
/// —————————————————————————————————————————————————————

class ProfileMetaModel {
  final int? profileCompletion;
  final bool? isProfileVerified;
  final bool? isOpenToWork;
  final bool? resumeUploaded;
  final int? profileViews;
  final int? savedJobs;
  final int? totalApplications;
  final DateTime? lastActiveAt;

  ProfileMetaModel({
    required this.profileCompletion,
    required this.isProfileVerified,
    required this.isOpenToWork,
    required this.resumeUploaded,
    required this.profileViews,
    required this.savedJobs,
    required this.totalApplications,
    required this.lastActiveAt,
  });

  factory ProfileMetaModel.fromJson(Map<String, dynamic> json) {
    return ProfileMetaModel(
      profileCompletion: json['profileCompletion'],
      isProfileVerified: json['isProfileVerified'],
      isOpenToWork: json['isOpenToWork'],
      resumeUploaded: json['resumeUploaded'],
      profileViews: json['profileViews'],
      savedJobs: json['savedJobs'],
      totalApplications: json['totalApplications'],
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.parse(json['lastActiveAt'])
          : null,
    );
  }
}
