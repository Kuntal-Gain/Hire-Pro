import 'package:flutter/material.dart';
import 'package:hire_pro/core/constants/color_constants.dart';
import 'package:hire_pro/core/constants/server_constants.dart';
import 'package:hire_pro/core/constants/sizes_constants.dart';
import 'package:hire_pro/core/network/client_manager.dart';
import 'package:hire_pro/features/profile/model/profile_request_model.dart';
import 'package:hire_pro/shared/widgets/buttons/primary_button.dart';
import 'package:hire_pro/shared/widgets/form/app_chip_input_field.dart';
import 'package:hire_pro/shared/widgets/form/app_date_field.dart';
import 'package:hire_pro/shared/widgets/form/app_dropdown_field.dart';
import 'package:hire_pro/shared/widgets/form/app_text_field.dart';
import 'package:hire_pro/shared/widgets/form/app_upload_field.dart';
import 'package:hire_pro/shared/widgets/form/section_card.dart';

class ProfessionalDetailsStep extends StatelessWidget {
  const ProfessionalDetailsStep({
    super.key,
    required this.totalExperience,
    required this.skills,
    required this.workHistory,
    required this.projects,
    required this.resume,
    required this.onTotalExperienceChanged,
    required this.onSkillsChanged,
    required this.onWorkHistoryChanged,
    required this.onProjectsChanged,
    required this.onResumeChanged,
  });

  final num totalExperience;
  final List<SkillItem> skills;
  final List<WorkHistoryItem> workHistory;
  final List<ProjectItem> projects;
  final ResumeItem? resume;
  final ValueChanged<num> onTotalExperienceChanged;
  final ValueChanged<List<SkillItem>> onSkillsChanged;
  final ValueChanged<List<WorkHistoryItem>> onWorkHistoryChanged;
  final ValueChanged<List<ProjectItem>> onProjectsChanged;
  final ValueChanged<ResumeItem?> onResumeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppUploadField(
          label: 'Resume',
          hint: 'Upload your resume (PDF)',
          icon: Icons.description_outlined,
          bucket: Buckets.resumes,
          pathPrefix: SupabaseManager.currentUserId ?? 'anonymous',
          allowedExtensions: const ['pdf'],
          fileName: resume?.name,
          onUploaded: (url) => onResumeChanged(
            ResumeItem(name: url.split('/').last, url: url, uploadedAt: DateTime.now()),
          ),
          onRemove: () => onResumeChanged(null),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Total experience (years)',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          initialValue: totalExperience == 0 ? '' : totalExperience.toString(),
          onChanged: (v) => onTotalExperienceChanged(num.tryParse(v) ?? 0),
        ),
        SizedBox(height: AppSizes.s24),
        AppChipInputField(
          label: 'Skills',
          hint: 'e.g. Flutter — press enter',
          values: skills.map((e) => e.name).toList(),
          onChanged: (names) {
            onSkillsChanged(
              names
                  .map(
                    (n) => skills.firstWhere(
                      (s) => s.name == n,
                      orElse: () => SkillItem(name: n, yearsOfExperience: 0),
                    ),
                  )
                  .toList(),
            );
          },
        ),
        SizedBox(height: AppSizes.s28),
        Text(
          'Work history',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColor.textPrimary),
        ),
        SizedBox(height: AppSizes.s12),
        for (int i = 0; i < workHistory.length; i++) ...[
          SectionCard(
            title: 'Work history ${i + 1}',
            onRemove: () {
              final list = [...workHistory]..removeAt(i);
              onWorkHistoryChanged(list);
            },
            child: _WorkHistoryForm(
              item: workHistory[i],
              onChanged: (v) {
                final list = [...workHistory];
                list[i] = v;
                onWorkHistoryChanged(list);
              },
            ),
          ),
          SizedBox(height: AppSizes.s16),
        ],
        PrimaryButton(
          label: 'Add work history',
          icon: Icons.add_rounded,
          isOutlined: true,
          width: double.infinity,
          onTap: () => onWorkHistoryChanged([
            ...workHistory,
            WorkHistoryItem(
              companyId: null,
              companyName: '',
              designation: '',
              employmentType: null,
              workMode: null,
              location: '',
              startDate: null,
              endDate: null,
              currentlyWorking: false,
              description: '',
            ),
          ]),
        ),
        SizedBox(height: AppSizes.s28),
        Text(
          'Projects',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColor.textPrimary),
        ),
        SizedBox(height: AppSizes.s12),
        for (int i = 0; i < projects.length; i++) ...[
          SectionCard(
            title: 'Project ${i + 1}',
            onRemove: () {
              final list = [...projects]..removeAt(i);
              onProjectsChanged(list);
            },
            child: _ProjectForm(
              item: projects[i],
              onChanged: (v) {
                final list = [...projects];
                list[i] = v;
                onProjectsChanged(list);
              },
            ),
          ),
          SizedBox(height: AppSizes.s16),
        ],
        PrimaryButton(
          label: 'Add project',
          icon: Icons.add_rounded,
          isOutlined: true,
          width: double.infinity,
          onTap: () => onProjectsChanged([
            ...projects,
            ProjectItem(title: '', description: '', technologies: const [], projectUrl: '', githubUrl: ''),
          ]),
        ),
      ],
    );
  }
}

class _WorkHistoryForm extends StatelessWidget {
  const _WorkHistoryForm({required this.item, required this.onChanged});

  final WorkHistoryItem item;
  final ValueChanged<WorkHistoryItem> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'Company name',
          initialValue: item.companyName,
          onChanged: (v) => onChanged(_copy(companyName: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Designation',
          initialValue: item.designation,
          onChanged: (v) => onChanged(_copy(designation: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppDropdownField<EmploymentType>(
          label: 'Employment type',
          items: EmploymentType.values,
          value: item.employmentType == null
              ? null
              : EmploymentType.values.firstWhere((e) => e.label == item.employmentType, orElse: () => EmploymentType.FULL_TIME),
          labelBuilder: (v) => v.label,
          onChanged: (v) => onChanged(_copy(employmentType: v?.label)),
        ),
        SizedBox(height: AppSizes.s16),
        AppDropdownField<WorkMode>(
          label: 'Work mode',
          items: WorkMode.values,
          value: item.workMode == null
              ? null
              : WorkMode.values.firstWhere((e) => e.label == item.workMode, orElse: () => WorkMode.ONSITE),
          labelBuilder: (v) => v.label,
          onChanged: (v) => onChanged(_copy(workMode: v?.label)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Location',
          initialValue: item.location,
          onChanged: (v) => onChanged(_copy(location: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppDateField(
          label: 'Start date',
          value: item.startDate,
          lastDate: DateTime.now(),
          onChanged: (v) => onChanged(_copy(startDate: v)),
        ),
        SizedBox(height: AppSizes.s16),
        if (item.currentlyWorking != true)
          AppDateField(
            label: 'End date',
            value: item.endDate,
            lastDate: DateTime.now(),
            onChanged: (v) => onChanged(_copy(endDate: v)),
          ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: item.currentlyWorking ?? false,
          activeThumbColor: AppColor.primary,
          title: Text(
            'Currently working here',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColor.textPrimary),
          ),
          onChanged: (v) => onChanged(_copy(currentlyWorking: v, endDate: v ? null : item.endDate, clearEndDate: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Description',
          initialValue: item.description,
          maxLines: 4,
          minLines: 2,
          onChanged: (v) => onChanged(_copy(description: v)),
        ),
      ],
    );
  }

  WorkHistoryItem _copy({
    String? companyId,
    String? companyName,
    String? designation,
    String? employmentType,
    String? workMode,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    bool clearEndDate = false,
    bool? currentlyWorking,
    String? description,
  }) {
    return WorkHistoryItem(
      companyId: companyId ?? item.companyId,
      companyName: companyName ?? item.companyName,
      designation: designation ?? item.designation,
      employmentType: employmentType ?? item.employmentType,
      workMode: workMode ?? item.workMode,
      location: location ?? item.location,
      startDate: startDate ?? item.startDate,
      endDate: clearEndDate ? null : (endDate ?? item.endDate),
      currentlyWorking: currentlyWorking ?? item.currentlyWorking,
      description: description ?? item.description,
    );
  }
}

class _ProjectForm extends StatelessWidget {
  const _ProjectForm({required this.item, required this.onChanged});

  final ProjectItem item;
  final ValueChanged<ProjectItem> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'Title',
          initialValue: item.title,
          onChanged: (v) => onChanged(_copy(title: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Description',
          initialValue: item.description,
          maxLines: 4,
          minLines: 2,
          onChanged: (v) => onChanged(_copy(description: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppChipInputField(
          label: 'Technologies',
          hint: 'e.g. Flutter — press enter',
          values: item.technologies ?? const [],
          onChanged: (v) => onChanged(_copy(technologies: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Project URL',
          keyboardType: TextInputType.url,
          initialValue: item.projectUrl,
          onChanged: (v) => onChanged(_copy(projectUrl: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'GitHub URL',
          keyboardType: TextInputType.url,
          initialValue: item.githubUrl,
          onChanged: (v) => onChanged(_copy(githubUrl: v)),
        ),
      ],
    );
  }

  ProjectItem _copy({
    String? title,
    String? description,
    List<String>? technologies,
    String? projectUrl,
    String? githubUrl,
  }) {
    return ProjectItem(
      title: title ?? item.title,
      description: description ?? item.description,
      technologies: technologies ?? item.technologies,
      projectUrl: projectUrl ?? item.projectUrl,
      githubUrl: githubUrl ?? item.githubUrl,
    );
  }
}
