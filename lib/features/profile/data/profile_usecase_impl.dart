import 'package:hire_pro/core/constants/server_constants.dart';
import 'package:hire_pro/core/network/client_manager.dart';
import 'package:hire_pro/core/network/resource.dart';

import 'package:hire_pro/features/profile/model/applicant_model.dart';

import 'package:hire_pro/features/profile/model/profile_request_model.dart';

import 'profile_usecase.dart';

class ProfileUsecaseImpl implements ProfileUsecase {
  @override
  Future<Resource<void>> createApplicantProfile(
    ApplicantProfileRequestModel applicant,
  ) async {
    try {
      final res = await SupabaseManager.from(
        Tables.candidates,
      ).insert(applicant.toJson());

      await SupabaseManager.from(
        Tables.users,
      ).upsert({'is_profile_created': true});

      return Resource.success();
    } catch (e) {
      return Resource.failure(e);
    }
  }

  @override
  Future<Resource<ApplicantProfileModel>> getApplicantProfileById(
    String userId,
  ) async {
    try {
      final json = await SupabaseManager.from(
        Tables.candidates,
      ).select().eq('user_id', userId).single();

      return Resource.success(ApplicantProfileModel.fromJson(json));
    } catch (e) {
      return Resource.failure(e);
    }
  }

  @override
  Future<Resource<ApplicantProfileModel>> getMyApplicantProfile() async {
    try {
      final json = await SupabaseManager.from(
        Tables.candidates,
      ).select().eq('user_id', SupabaseManager.currentUserId!).single();

      return Resource.success(ApplicantProfileModel.fromJson(json));
    } catch (e) {
      return Resource.failure(e);
    }
  }
}
