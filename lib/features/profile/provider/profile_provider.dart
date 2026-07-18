import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hire_pro/core/extensions/resource_extension.dart';
import 'package:hire_pro/core/network/locator.dart';
import 'package:hire_pro/features/profile/model/applicant_model.dart';
import 'package:hire_pro/features/profile/model/profile_request_model.dart';

class ApplicantProfileNotifier extends AsyncNotifier<ApplicantProfileModel?> {
  @override
  Future<ApplicantProfileModel?> build() async {
    final uc = ref.read(profileServiceProvider);
    return (await uc.getMyApplicantProfile()).unwrap();
  }

  Future<void> createApplicantProfile(
    ApplicantProfileRequestModel applicant,
  ) async {
    final uc = ref.read(profileServiceProvider);

    (await uc.createApplicantProfile(applicant)).unwrap();

    ref.invalidateSelf();
    await future;
  }

  Future<ApplicantProfileModel?> getApplicantProfileById(String userId) async {
    final uc = ref.read(profileServiceProvider);

    return (await uc.getApplicantProfileById(userId)).unwrap();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final applicantProfileProvider =
    AsyncNotifierProvider<ApplicantProfileNotifier, ApplicantProfileModel?>(
      ApplicantProfileNotifier.new,
    );
