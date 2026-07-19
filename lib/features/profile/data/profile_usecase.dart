import 'package:hire_pro/features/profile/model/applicant_model.dart';
import 'package:hire_pro/features/profile/model/company_model.dart';

import '../../../core/network/resource.dart';
import '../model/profile_request_model.dart';

abstract class ProfileUsecase {
  Future<Resource<void>> createApplicantProfile(
    ApplicantProfileRequestModel applicant,
  );

  Future<Resource<void>> createEmployerProfile(
    EmployerProfileRequestModel employer,
  );

  /// Retrives current logged in applicant profile from the server.
  Future<Resource<ApplicantProfileModel>> getMyApplicantProfile();

  // Retrives applicant profile from the server by userId for employers.
  Future<Resource<ApplicantProfileModel>> getApplicantProfileById(
    String userId,
  );


  Future<Resource<List<CompanyModel>>> getCompanies();

  Future<Resource<CompanyModel>> createCompany(CompanyRequestModel company);
}
