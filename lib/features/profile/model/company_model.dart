enum CompanyType { Startup , MNC , Govt , No_Profit }


class CompanyRequestModel {
  final String? name;
  final String? description;
  final String? industryType;
  final CompanyType? companyType;
  final String? companySize;
  final int? foundedYear;
  final String? website;
  final String? logo;
  final String? coverImage;
  final String? email;
  final String? phone;
  final String? status;
  final bool? verified;
  final List<CompanyLocation>? locations;
  final List<ImportantFigure>? importantFigures;
  final List<String>? policies;

  CompanyRequestModel({
    required this.name,
    required this.description,
    required this.industryType,
    required this.companyType,
    required this.companySize,
    required this.foundedYear,
    required this.website,
    required this.logo,
    required this.coverImage,
    required this.email,
    required this.phone,
    required this.status,
    required this.verified,
    required this.locations,
    required this.importantFigures,
    required this.policies,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'industry_type': industryType,
      'company_type': companyType?.name,
      'company_size': companySize,
      'founded_year': foundedYear,
      'website': website,
      'logo': logo,
      'cover_image': coverImage,
      'email': email,
      'phone': phone,
      'status': status,
      'verified': verified,
      'locations': locations?.map((e) => e.toJson()).toList(),
      'important_figures': importantFigures?.map((e) => e.toJson()).toList(),
      'policies': policies,
    };
  }
}




class CompanyModel {
  final String? compId;
  final String? name;
  final String? description;
  final String? industryType;
  final String? companyType;
  final String? companySize;
  final int? foundedYear;
  final String? website;
  final String? logo;
  final String? coverImage;
  final String? email;
  final String? phone;
  final String? status;
  final bool? verified;
  final List<CompanyLocation>? locations;
  final List<ImportantFigure>? importantFigures;
  final List<String>? policies;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CompanyModel({
    this.compId,
    this.name,
    this.description,
    this.industryType,
    this.companyType,
    this.companySize,
    this.foundedYear,
    this.website,
    this.logo,
    this.coverImage,
    this.email,
    this.phone,
    this.status,
    this.verified,
    this.locations,
    this.importantFigures,
    this.policies,
    this.createdAt,
    this.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      compId: json['comp_id'],
      name: json['name'],
      description: json['description'],
      industryType: json['industry_type'],
      companyType: json['company_type'],
      companySize: json['company_size'],
      foundedYear: json['founded_year'],
      website: json['website'],
      logo: json['logo'],
      coverImage: json['cover_image'],
      email: json['email'],
      phone: json['phone'],
      status: json['status'],
      verified: json['verified'],
      locations: (json['locations'] as List<dynamic>?)
          ?.map((e) => CompanyLocation.fromJson(e))
          .toList(),
      importantFigures: (json['important_figures'] as List<dynamic>?)
          ?.map((e) => ImportantFigure.fromJson(e))
          .toList(),
      policies: (json['policies'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comp_id': compId,
      'name': name,
      'description': description,
      'industry_type': industryType,
      'company_type': companyType,
      'company_size': companySize,
      'founded_year': foundedYear,
      'website': website,
      'logo': logo,
      'cover_image': coverImage,
      'email': email,
      'phone': phone,
      'status': status,
      'verified': verified,
      'locations': locations?.map((e) => e.toJson()).toList(),
      'important_figures': importantFigures?.map((e) => e.toJson()).toList(),
      'policies': policies,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class CompanyLocation {
  final String? city;
  final String? state;
  final String? country;

  const CompanyLocation({this.city, this.state, this.country});

  factory CompanyLocation.fromJson(Map<String, dynamic> json) {
    return CompanyLocation(
      city: json['city'],
      state: json['state'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'city': city, 'state': state, 'country': country};
  }
}

class ImportantFigure {
  final String? staffId;
  final String? name;
  final String? designation;

  const ImportantFigure({this.staffId, this.name, this.designation});

  factory ImportantFigure.fromJson(Map<String, dynamic> json) {
    return ImportantFigure(
      staffId: json['staff_id'],
      name: json['name'],
      designation: json['designation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'staff_id': staffId, 'name': name, 'designation': designation};
  }
}
