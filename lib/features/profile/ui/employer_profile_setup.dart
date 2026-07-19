import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hire_pro/core/constants/color_constants.dart';
import 'package:hire_pro/core/constants/sizes_constants.dart';
import 'package:hire_pro/core/network/client_manager.dart';
import 'package:hire_pro/core/router/app_routes.dart';
import 'package:hire_pro/features/profile/model/company_model.dart';
import 'package:hire_pro/features/profile/model/profile_request_model.dart';
import 'package:hire_pro/features/profile/provider/profile_provider.dart';
import 'package:hire_pro/features/profile/ui/steps/company_step.dart';
import 'package:hire_pro/features/profile/ui/steps/personal_details_step.dart';
import 'package:hire_pro/features/profile/ui/steps/professional_details_step.dart';
import 'package:hire_pro/shared/widgets/buttons/primary_button.dart';
import 'package:hire_pro/shared/widgets/common_app_bar.dart';
import 'package:hire_pro/shared/widgets/form/step_indicator.dart';

class EmployerProfileSetupScreen extends ConsumerStatefulWidget {
  const EmployerProfileSetupScreen({super.key});

  @override
  ConsumerState<EmployerProfileSetupScreen> createState() =>
      _EmployerProfileSetupScreenState();
}

class _EmployerProfileSetupScreenState
    extends ConsumerState<EmployerProfileSetupScreen> {
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

  num _totalExperience = 0;
  List<SkillItem> _skills = [];
  List<WorkHistoryItem> _workHistory = [];
  List<ProjectItem> _projects = [];
  ResumeItem? _resume;

  CompanyModel? _selectedCompany;
  bool _isAddingNewCompany = false;
  CompanyRequestModel _newCompany = CompanyRequestModel(
    name: null,
    description: null,
    industryType: null,
    companyType: null,
    companySize: null,
    foundedYear: null,
    website: null,
    logo: null,
    coverImage: null,
    email: null,
    phone: null,
    status: null,
    verified: null,
    locations: const [],
    importantFigures: const [],
    policies: const [],
  );

  static const _steps = [
    StepIndicatorItem(label: 'Personal'),
    StepIndicatorItem(label: 'Professional', isOptional: true),
    StepIndicatorItem(label: 'Company'),
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
    if (_step == 0 && !(_personalFormKey.currentState?.validate() ?? false)) {
      return;
    }
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
    if (_selectedCompany == null && !_isAddingNewCompany) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select or add a company')));
      return;
    }
    if (_isAddingNewCompany && (_newCompany.name == null || _newCompany.name!.trim().isEmpty)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Company name is required')));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      String companyId;
      if (_isAddingNewCompany) {
        final created = await ref
            .read(companyProvider.notifier)
            .createCompany(_newCompany);
        if (created?.compId == null) {
          throw Exception('Failed to create company');
        }
        companyId = created!.compId!;
      } else {
        companyId = _selectedCompany!.compId!;
      }

      final employer = EmployerProfileRequestModel(
        userId: SupabaseManager.currentUserId,
        personal: _personal,
        professional: ProfessionalDetailsRequestModel(
          totalExperience: _totalExperience,
          skills: _skills,
          workHistory: _workHistory,
          projects: _projects,
          resume: _resume,
        ),
        companyId: companyId,
      );

      await ref
          .read(employerProfileProvider.notifier)
          .createEmployerProfile(employer);

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
                    child: CompanyStep(
                      selectedCompany: _selectedCompany,
                      isAddingNew: _isAddingNewCompany,
                      newCompany: _newCompany,
                      onCompanySelected: (c) => setState(() {
                        _selectedCompany = c;
                        _isAddingNewCompany = false;
                      }),
                      onStartAddNew: () => setState(() {
                        _isAddingNewCompany = true;
                        _selectedCompany = null;
                      }),
                      onCancelAddNew: () => setState(() {
                        _isAddingNewCompany = false;
                      }),
                      onNewCompanyChanged: (v) =>
                          setState(() => _newCompany = v),
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
