import 'package:flutter/material.dart';
import 'package:hire_pro/core/constants/color_constants.dart';
import 'package:hire_pro/core/constants/sizes_constants.dart';
import 'package:hire_pro/features/profile/model/profile_request_model.dart';
import 'package:hire_pro/shared/widgets/form/app_chip_input_field.dart';
import 'package:hire_pro/shared/widgets/form/app_dropdown_field.dart';
import 'package:hire_pro/shared/widgets/form/app_text_field.dart';

class JobPreferencesStep extends StatelessWidget {
  const JobPreferencesStep({super.key, required this.data, required this.onChanged});

  final JobPreferencesRequestModel data;
  final ValueChanged<JobPreferencesRequestModel> onChanged;

  @override
  Widget build(BuildContext context) {
    final salary = data.expectedSalary ?? ExpectedSalaryRequestModel(minSalary: null, maxSalary: null, currency: null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppChipInputField(
          label: 'Preferred job titles',
          hint: 'e.g. Flutter Developer — press enter',
          values: data.preferredJobTitles ?? const [],
          onChanged: (v) => onChanged(_copy(preferredJobTitles: v)),
        ),
        SizedBox(height: AppSizes.s24),
        AppMultiSelectChips<EmploymentType>(
          label: 'Employment types',
          items: EmploymentType.values,
          selected: (data.employmentTypes ?? const [])
              .map((s) => EmploymentType.values.firstWhere((e) => e.label == s, orElse: () => EmploymentType.FULL_TIME))
              .toList(),
          labelBuilder: (v) => v.label,
          onChanged: (v) => onChanged(_copy(employmentTypes: v.map((e) => e.label).toList())),
        ),
        SizedBox(height: AppSizes.s24),
        AppMultiSelectChips<WorkMode>(
          label: 'Work modes',
          items: WorkMode.values,
          selected: (data.workModes ?? const [])
              .map((s) => WorkMode.values.firstWhere((e) => e.label == s, orElse: () => WorkMode.ONSITE))
              .toList(),
          labelBuilder: (v) => v.label,
          onChanged: (v) => onChanged(_copy(workModes: v.map((e) => e.label).toList())),
        ),
        SizedBox(height: AppSizes.s24),
        AppChipInputField(
          label: 'Preferred locations',
          hint: 'e.g. Bengaluru — press enter',
          values: data.preferredLocations ?? const [],
          onChanged: (v) => onChanged(_copy(preferredLocations: v)),
        ),
        SizedBox(height: AppSizes.s24),
        Text(
          'Expected salary',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColor.textPrimary),
        ),
        SizedBox(height: AppSizes.s8),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                hint: 'Min',
                keyboardType: TextInputType.number,
                initialValue: salary.minSalary?.toString(),
                onChanged: (v) => onChanged(
                  _copy(expectedSalary: ExpectedSalaryRequestModel(minSalary: num.tryParse(v), maxSalary: salary.maxSalary, currency: salary.currency)),
                ),
              ),
            ),
            SizedBox(width: AppSizes.s12),
            Expanded(
              child: AppTextField(
                hint: 'Max',
                keyboardType: TextInputType.number,
                initialValue: salary.maxSalary?.toString(),
                onChanged: (v) => onChanged(
                  _copy(expectedSalary: ExpectedSalaryRequestModel(minSalary: salary.minSalary, maxSalary: num.tryParse(v), currency: salary.currency)),
                ),
              ),
            ),
            SizedBox(width: AppSizes.s12),
            SizedBox(
              width: 100,
              child: AppDropdownField<CurrencyType>(
                items: CurrencyType.values,
                value: salary.currency,
                labelBuilder: (v) => v.name,
                onChanged: (v) => onChanged(
                  _copy(expectedSalary: ExpectedSalaryRequestModel(minSalary: salary.minSalary, maxSalary: salary.maxSalary, currency: v)),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.s24),
        AppTextField(
          label: 'Notice period (days)',
          keyboardType: TextInputType.number,
          initialValue: data.noticePeriodInDays == 0 ? '' : data.noticePeriodInDays.toString(),
          onChanged: (v) => onChanged(_copy(noticePeriodInDays: int.tryParse(v))),
        ),
        SizedBox(height: AppSizes.s8),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: data.openToRelocation,
          activeThumbColor: AppColor.primary,
          title: Text(
            'Open to relocation',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColor.textPrimary),
          ),
          onChanged: (v) => onChanged(_copy(openToRelocation: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppChipInputField(
          label: 'Preferred industries',
          hint: 'e.g. Information Technology — press enter',
          values: data.preferredIndustries ?? const [],
          onChanged: (v) => onChanged(_copy(preferredIndustries: v)),
        ),
        SizedBox(height: AppSizes.s24),
        AppChipInputField(
          label: 'Preferred departments',
          hint: 'e.g. Engineering — press enter',
          values: data.preferredDepartments ?? const [],
          onChanged: (v) => onChanged(_copy(preferredDepartments: v)),
        ),
      ],
    );
  }

  JobPreferencesRequestModel _copy({
    List<String>? preferredJobTitles,
    List<String>? employmentTypes,
    List<String>? workModes,
    List<String>? preferredLocations,
    ExpectedSalaryRequestModel? expectedSalary,
    int? noticePeriodInDays,
    bool? openToRelocation,
    List<String>? preferredIndustries,
    List<String>? preferredDepartments,
  }) {
    return JobPreferencesRequestModel(
      preferredJobTitles: preferredJobTitles ?? data.preferredJobTitles,
      employmentTypes: employmentTypes ?? data.employmentTypes,
      workModes: workModes ?? data.workModes,
      preferredLocations: preferredLocations ?? data.preferredLocations,
      expectedSalary: expectedSalary ?? data.expectedSalary,
      noticePeriodInDays: noticePeriodInDays ?? data.noticePeriodInDays,
      openToRelocation: openToRelocation ?? data.openToRelocation,
      preferredIndustries: preferredIndustries ?? data.preferredIndustries,
      preferredDepartments: preferredDepartments ?? data.preferredDepartments,
    );
  }
}
