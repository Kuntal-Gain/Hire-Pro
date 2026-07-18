import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hire_pro/core/constants/color_constants.dart';
import 'package:hire_pro/core/constants/sizes_constants.dart';
import 'package:hire_pro/core/network/client_manager.dart';
import 'package:hire_pro/core/router/app_routes.dart';
import 'package:hire_pro/features/profile/model/profile_request_model.dart';
import 'package:hire_pro/features/profile/provider/profile_provider.dart';
import 'package:hire_pro/features/profile/ui/steps/academic_details_step.dart';
import 'package:hire_pro/features/profile/ui/steps/job_preferences_step.dart';
import 'package:hire_pro/features/profile/ui/steps/personal_details_step.dart';
import 'package:hire_pro/features/profile/ui/steps/professional_details_step.dart';
import 'package:hire_pro/shared/widgets/buttons/primary_button.dart';
import 'package:hire_pro/shared/widgets/common_app_bar.dart';
import 'package:hire_pro/shared/widgets/form/step_indicator.dart';

class ApplicantProfileSetupScreen extends ConsumerStatefulWidget {
  const ApplicantProfileSetupScreen({super.key});

  @override
  ConsumerState<ApplicantProfileSetupScreen> createState() =>
      _ApplicantProfileSetupScreenState();
}

class _ApplicantProfileSetupScreenState
    extends ConsumerState<ApplicantProfileSetupScreen> {
  final _pageController = PageController();
  final _personalFormKey = GlobalKey<FormState>();

  int _step = 0;
  bool _isSubmitting = false;

  PersonalDetailsRequestModel _personal = PersonalDetailsRequestModel(
    fullName: null,
    profileImage: null,
    headline: null,
    bio: null,
    phone: null,
    email: null,
    gender: null,
    dateOfBirth: null,
    location: null,
    portfolio: null,
    linkedin: null,
    github: null,
    website: null,
  );

  List<AcademicHistoryItem> _education = [];
  List<CertificationItem> _certifications = [];

  num _totalExperience = 0;
  List<SkillItem> _skills = [];
  List<WorkHistoryItem> _workHistory = [];
  List<ProjectItem> _projects = [];
  ResumeItem? _resume;

  JobPreferencesRequestModel _preferences = JobPreferencesRequestModel(
    preferredJobTitles: const [],
    employmentTypes: const [],
    workModes: const [],
    preferredLocations: const [],
    expectedSalary: null,
    noticePeriodInDays: 0,
    openToRelocation: false,
    preferredIndustries: const [],
    preferredDepartments: const [],
  );

  static const _steps = [
    StepIndicatorItem(label: 'Personal'),
    StepIndicatorItem(label: 'Academic'),
    StepIndicatorItem(label: 'Professional', isOptional: true),
    StepIndicatorItem(label: 'Preferences', isOptional: true),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int step) {
    setState(() => _step = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _next() {
    if (_step == 0 && !(_personalFormKey.currentState?.validate() ?? false))
      return;
    if (_step == _steps.length - 1) {
      _submit();
      return;
    }
    _goTo(_step + 1);
  }

  void _back() {
    if (_step == 0) return;
    _goTo(_step - 1);
  }

  void _skip() => _goTo(_step + 1);

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    try {
      final applicant = ApplicantProfileRequestModel(
        userId: SupabaseManager.currentUserId,
        personalDetails: _personal,
        academicDetails: AcademicDetailsRequestModel(
          education: _education,
          certifications: _certifications,
        ),
        professionalDetails: ProfessionalDetailsRequestModel(
          totalExperience: _totalExperience,
          skills: _skills,
          workHistory: _workHistory,
          projects: _projects,
          resume: _resume,
        ),
        jobPreferences: _preferences,
      );

      await ref
          .read(applicantProfileProvider.notifier)
          .createApplicantProfile(applicant);

      if (!context.mounted) return;
      context.go(AppRoutes.home);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (context.mounted) setState(() => _isSubmitting = false);
    }
  }

  bool get _isOptionalStep => _steps[_step].isOptional;
  bool get _isLastStep => _step == _steps.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: const CommonAppBar(title: 'Complete your profile'),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.s16,
                vertical: AppSizes.s16,
              ),
              child: StepIndicator(steps: _steps, currentStep: _step),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _step = i),
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.s16),
                    child: Form(
                      key: _personalFormKey,
                      child: PersonalDetailsStep(
                        data: _personal,
                        onChanged: (v) => setState(() => _personal = v),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.s16),
                    child: AcademicDetailsStep(
                      education: _education,
                      certifications: _certifications,
                      onEducationChanged: (v) => setState(() => _education = v),
                      onCertificationsChanged: (v) =>
                          setState(() => _certifications = v),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.s16),
                    child: ProfessionalDetailsStep(
                      totalExperience: _totalExperience,
                      skills: _skills,
                      workHistory: _workHistory,
                      projects: _projects,
                      resume: _resume,
                      onTotalExperienceChanged: (v) =>
                          setState(() => _totalExperience = v),
                      onSkillsChanged: (v) => setState(() => _skills = v),
                      onWorkHistoryChanged: (v) =>
                          setState(() => _workHistory = v),
                      onProjectsChanged: (v) => setState(() => _projects = v),
                      onResumeChanged: (v) => setState(() => _resume = v),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.s16),
                    child: JobPreferencesStep(
                      data: _preferences,
                      onChanged: (v) => setState(() => _preferences = v),
                    ),
                  ),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.s16,
        AppSizes.s8,
        AppSizes.s16,
        AppSizes.s16,
      ),
      child: Row(
        children: [
          if (_step > 0)
            Expanded(
              child: PrimaryButton(
                label: 'Back',
                isOutlined: true,
                onTap: _isSubmitting ? null : _back,
              ),
            ),
          if (_step > 0) SizedBox(width: AppSizes.s12),
          if (_isOptionalStep && !_isLastStep)
            Expanded(
              child: PrimaryButton(
                label: 'Skip',
                isOutlined: true,
                onTap: _isSubmitting ? null : _skip,
              ),
            ),
          if (_isOptionalStep && !_isLastStep) SizedBox(width: AppSizes.s12),
          Expanded(
            flex: 2,
            child: PrimaryButton(
              label: _isLastStep ? 'Finish' : 'Next',
              isLoading: _isSubmitting,
              onTap: _isSubmitting ? null : _next,
            ),
          ),
        ],
      ),
    );
  }
}
