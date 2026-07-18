import 'package:flutter/material.dart';
import 'package:hire_pro/core/constants/color_constants.dart';
import 'package:hire_pro/core/constants/sizes_constants.dart';
import 'package:hire_pro/features/profile/model/profile_request_model.dart';
import 'package:hire_pro/shared/widgets/buttons/primary_button.dart';
import 'package:hire_pro/shared/widgets/form/app_date_field.dart';
import 'package:hire_pro/shared/widgets/form/app_dropdown_field.dart';
import 'package:hire_pro/shared/widgets/form/app_text_field.dart';
import 'package:hire_pro/shared/widgets/form/section_card.dart';

class AcademicDetailsStep extends StatelessWidget {
  const AcademicDetailsStep({
    super.key,
    required this.education,
    required this.certifications,
    required this.onEducationChanged,
    required this.onCertificationsChanged,
  });

  final List<AcademicHistoryItem> education;
  final List<CertificationItem> certifications;
  final ValueChanged<List<AcademicHistoryItem>> onEducationChanged;
  final ValueChanged<List<CertificationItem>> onCertificationsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Education',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColor.textPrimary),
        ),
        SizedBox(height: AppSizes.s12),
        for (int i = 0; i < education.length; i++) ...[
          SectionCard(
            title: 'Education ${i + 1}',
            onRemove: () {
              final list = [...education]..removeAt(i);
              onEducationChanged(list);
            },
            child: _EducationForm(
              item: education[i],
              onChanged: (v) {
                final list = [...education];
                list[i] = v;
                onEducationChanged(list);
              },
            ),
          ),
          SizedBox(height: AppSizes.s16),
        ],
        PrimaryButton(
          label: 'Add education',
          icon: Icons.add_rounded,
          isOutlined: true,
          width: double.infinity,
          onTap: () => onEducationChanged([
            ...education,
            AcademicHistoryItem(
              degree: DegreeType.BTECH,
              specialization: SpecializationType.COMPUTER_SCIENCE,
              institution: '',
              boardOrUniversity: '',
              startYear: DateTime.now().year,
              endYear: DateTime.now().year,
              grade: GradeType.CGPA,
              gradeType: '',
            ),
          ]),
        ),
        SizedBox(height: AppSizes.s28),
        Text(
          'Certifications',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColor.textPrimary),
        ),
        SizedBox(height: AppSizes.s12),
        for (int i = 0; i < certifications.length; i++) ...[
          SectionCard(
            title: 'Certification ${i + 1}',
            onRemove: () {
              final list = [...certifications]..removeAt(i);
              onCertificationsChanged(list);
            },
            child: _CertificationForm(
              item: certifications[i],
              onChanged: (v) {
                final list = [...certifications];
                list[i] = v;
                onCertificationsChanged(list);
              },
            ),
          ),
          SizedBox(height: AppSizes.s16),
        ],
        PrimaryButton(
          label: 'Add certification',
          icon: Icons.add_rounded,
          isOutlined: true,
          width: double.infinity,
          onTap: () => onCertificationsChanged([
            ...certifications,
            CertificationItem(
              name: '',
              issuingOrganization: '',
              issueDate: DateTime.now(),
              credentialId: '',
              credentialUrl: '',
            ),
          ]),
        ),
      ],
    );
  }
}

class _EducationForm extends StatelessWidget {
  const _EducationForm({required this.item, required this.onChanged});

  final AcademicHistoryItem item;
  final ValueChanged<AcademicHistoryItem> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDropdownField<DegreeType>(
          label: 'Degree',
          items: DegreeType.values,
          value: item.degree,
          labelBuilder: (v) => v.label,
          onChanged: (v) => onChanged(_copy(degree: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppDropdownField<SpecializationType>(
          label: 'Specialization',
          items: SpecializationType.values,
          value: item.specialization,
          labelBuilder: (v) => v.label,
          onChanged: (v) => onChanged(_copy(specialization: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Institution',
          initialValue: item.institution,
          onChanged: (v) => onChanged(_copy(institution: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Board / University',
          initialValue: item.boardOrUniversity,
          onChanged: (v) => onChanged(_copy(boardOrUniversity: v)),
        ),
        SizedBox(height: AppSizes.s16),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Start year',
                keyboardType: TextInputType.number,
                initialValue: item.startYear.toString(),
                onChanged: (v) => onChanged(_copy(startYear: int.tryParse(v))),
              ),
            ),
            SizedBox(width: AppSizes.s16),
            Expanded(
              child: AppTextField(
                label: 'End year',
                keyboardType: TextInputType.number,
                initialValue: item.endYear.toString(),
                onChanged: (v) => onChanged(_copy(endYear: int.tryParse(v))),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.s16),
        AppDropdownField<GradeType>(
          label: 'Grade type',
          items: GradeType.values,
          value: item.grade,
          labelBuilder: (v) => v.name,
          onChanged: (v) => onChanged(_copy(grade: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Grade / score',
          hint: 'e.g. 8.10 or 82%',
          initialValue: item.gradeType,
          onChanged: (v) => onChanged(_copy(gradeType: v)),
        ),
      ],
    );
  }

  AcademicHistoryItem _copy({
    DegreeType? degree,
    SpecializationType? specialization,
    String? institution,
    String? boardOrUniversity,
    int? startYear,
    int? endYear,
    GradeType? grade,
    String? gradeType,
  }) {
    return AcademicHistoryItem(
      degree: degree ?? item.degree,
      specialization: specialization ?? item.specialization,
      institution: institution ?? item.institution,
      boardOrUniversity: boardOrUniversity ?? item.boardOrUniversity,
      startYear: startYear ?? item.startYear,
      endYear: endYear ?? item.endYear,
      grade: grade ?? item.grade,
      gradeType: gradeType ?? item.gradeType,
    );
  }
}

class _CertificationForm extends StatelessWidget {
  const _CertificationForm({required this.item, required this.onChanged});

  final CertificationItem item;
  final ValueChanged<CertificationItem> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'Title',
          initialValue: item.name,
          onChanged: (v) => onChanged(_copy(name: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Issuer',
          initialValue: item.issuingOrganization,
          onChanged: (v) => onChanged(_copy(issuingOrganization: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppDateField(
          label: 'Issue date',
          value: item.issueDate,
          lastDate: DateTime.now(),
          onChanged: (v) => onChanged(_copy(issueDate: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppDateField(
          label: 'Expiration date (optional)',
          value: item.expirationDate,
          onChanged: (v) => onChanged(_copy(expirationDate: v, clearExpiration: v == null)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Credential ID',
          initialValue: item.credentialId,
          onChanged: (v) => onChanged(_copy(credentialId: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Credential URL',
          keyboardType: TextInputType.url,
          initialValue: item.credentialUrl,
          onChanged: (v) => onChanged(_copy(credentialUrl: v)),
        ),
      ],
    );
  }

  CertificationItem _copy({
    String? name,
    String? issuingOrganization,
    DateTime? issueDate,
    DateTime? expirationDate,
    bool clearExpiration = false,
    String? credentialId,
    String? credentialUrl,
  }) {
    return CertificationItem(
      name: name ?? item.name,
      issuingOrganization: issuingOrganization ?? item.issuingOrganization,
      issueDate: issueDate ?? item.issueDate,
      expirationDate: clearExpiration ? null : (expirationDate ?? item.expirationDate),
      credentialId: credentialId ?? item.credentialId,
      credentialUrl: credentialUrl ?? item.credentialUrl,
    );
  }
}
