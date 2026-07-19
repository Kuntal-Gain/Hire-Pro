import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hire_pro/core/constants/color_constants.dart';
import 'package:hire_pro/core/constants/sizes_constants.dart';
import 'package:hire_pro/features/profile/model/company_model.dart';
import 'package:hire_pro/features/profile/provider/profile_provider.dart';
import 'package:hire_pro/shared/widgets/form/app_chip_input_field.dart';
import 'package:hire_pro/shared/widgets/form/app_dropdown_field.dart';
import 'package:hire_pro/shared/widgets/form/app_text_field.dart';
import 'package:hire_pro/shared/widgets/form/section_card.dart';
import 'package:hire_pro/shared/widgets/buttons/primary_button.dart';

/// Step 3 of employer profile setup: pick an existing company from a
/// searchable list, or switch to "Add new company" and fill out a
/// [CompanyRequestModel] form inline. The newly created company (once
/// submitted) is what gets assigned to the employer profile.
class CompanyStep extends ConsumerWidget {
  const CompanyStep({
    super.key,
    required this.selectedCompany,
    required this.isAddingNew,
    required this.newCompany,
    required this.onCompanySelected,
    required this.onStartAddNew,
    required this.onCancelAddNew,
    required this.onNewCompanyChanged,
  });

  final CompanyModel? selectedCompany;
  final bool isAddingNew;
  final CompanyRequestModel newCompany;
  final ValueChanged<CompanyModel> onCompanySelected;
  final VoidCallback onStartAddNew;
  final VoidCallback onCancelAddNew;
  final ValueChanged<CompanyRequestModel> onNewCompanyChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companiesAsync = ref.watch(companyProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Company',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColor.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.s4),
        Text(
          'Select the company you work for, or add a new one.',
          style: TextStyle(fontSize: 12.5, color: AppColor.textSecondary),
        ),
        SizedBox(height: AppSizes.s16),
        if (!isAddingNew)
          companiesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text(
              'Failed to load companies: $e',
              style: TextStyle(color: AppColor.error, fontSize: 13),
            ),
            data: (companies) => _CompanySelector(
              companies: companies,
              selected: selectedCompany,
              onSelected: onCompanySelected,
              onAddNew: onStartAddNew,
            ),
          ),
        if (isAddingNew) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  'New company details',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColor.primaryDark,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onCancelAddNew,
                icon: const Icon(Icons.close_rounded, size: 16),
                label: const Text('Cancel'),
              ),
            ],
          ),
          SizedBox(height: AppSizes.s8),
          _NewCompanyForm(data: newCompany, onChanged: onNewCompanyChanged),
        ],
      ],
    );
  }
}

class _CompanySelector extends StatelessWidget {
  const _CompanySelector({
    required this.companies,
    required this.selected,
    required this.onSelected,
    required this.onAddNew,
  });

  final List<CompanyModel> companies;
  final CompanyModel? selected;
  final ValueChanged<CompanyModel> onSelected;
  final VoidCallback onAddNew;

  Future<void> _openPicker(BuildContext context) async {
    final result = await showModalBottomSheet<_PickerResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.r20)),
      ),
      builder: (_) => _CompanyPickerSheet(companies: companies),
    );

    if (result == null) return;
    if (result.addNew) {
      onAddNew();
    } else if (result.company != null) {
      onSelected(result.company!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openPicker(context),
      borderRadius: BorderRadius.circular(AppSizes.r12),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.s14,
          horizontal: AppSizes.s16,
        ),
        decoration: BoxDecoration(
          color: AppColor.textSecondary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppSizes.r12),
        ),
        child: Row(
          children: [
            Icon(Icons.apartment_rounded, size: 20, color: AppColor.textSecondary),
            SizedBox(width: AppSizes.s12),
            Expanded(
              child: Text(
                selected?.name ?? 'Select company',
                style: TextStyle(
                  fontSize: 14,
                  color: selected == null ? AppColor.textTertiary : AppColor.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.search_rounded, size: 18, color: AppColor.textSecondary),
            SizedBox(width: AppSizes.s8),
            Icon(Icons.keyboard_arrow_down_rounded, color: AppColor.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _PickerResult {
  final CompanyModel? company;
  final bool addNew;
  const _PickerResult.company(this.company) : addNew = false;
  const _PickerResult.addNew() : company = null, addNew = true;
}

class _CompanyPickerSheet extends StatefulWidget {
  const _CompanyPickerSheet({required this.companies});

  final List<CompanyModel> companies;

  @override
  State<_CompanyPickerSheet> createState() => _CompanyPickerSheetState();
}

class _CompanyPickerSheetState extends State<_CompanyPickerSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.trim().isEmpty
        ? widget.companies
        : widget.companies
              .where((c) => (c.name ?? '').toLowerCase().contains(_query.trim().toLowerCase()))
              .toList();

    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.s16,
        right: AppSizes.s16,
        top: AppSizes.s16,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.s16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select company',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColor.textPrimary),
          ),
          SizedBox(height: AppSizes.s12),
          AppTextField(
            controller: _searchCtrl,
            hint: 'Search companies',
            icon: Icons.search_rounded,
            onChanged: (v) => setState(() => _query = v),
          ),
          SizedBox(height: AppSizes.s12),
          InkWell(
            onTap: () => Navigator.of(context).pop(const _PickerResult.addNew()),
            borderRadius: BorderRadius.circular(AppSizes.r12),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: AppSizes.s12, horizontal: AppSizes.s12),
              decoration: BoxDecoration(
                color: AppColor.primaryContainer,
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
              child: Row(
                children: [
                  Icon(Icons.add_rounded, size: 20, color: AppColor.primaryDark),
                  SizedBox(width: AppSizes.s10),
                  Text(
                    'Add new company',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColor.primaryDark),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSizes.s8),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
            child: filtered.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'No companies found',
                      style: TextStyle(fontSize: 13, color: AppColor.textTertiary),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: AppColor.divider),
                    itemBuilder: (_, i) {
                      final c = filtered[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: AppColor.primaryContainer,
                          backgroundImage: (c.logo != null && c.logo!.isNotEmpty)
                              ? NetworkImage(c.logo!)
                              : null,
                          child: (c.logo == null || c.logo!.isEmpty)
                              ? Icon(Icons.apartment_rounded, size: 18, color: AppColor.primaryDark)
                              : null,
                        ),
                        title: Text(
                          c.name ?? 'Unnamed company',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColor.textPrimary),
                        ),
                        subtitle: c.industryType != null ? Text(c.industryType!) : null,
                        onTap: () => Navigator.of(context).pop(_PickerResult.company(c)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _NewCompanyForm extends StatelessWidget {
  const _NewCompanyForm({required this.data, required this.onChanged});

  final CompanyRequestModel data;
  final ValueChanged<CompanyRequestModel> onChanged;

  CompanyRequestModel _copy({
    String? name,
    String? description,
    String? industryType,
    CompanyType? companyType,
    String? companySize,
    int? foundedYear,
    String? website,
    String? logo,
    String? email,
    String? phone,
    List<CompanyLocation>? locations,
    List<ImportantFigure>? importantFigures,
    List<String>? policies,
  }) {
    return CompanyRequestModel(
      name: name ?? data.name,
      description: description ?? data.description,
      industryType: industryType ?? data.industryType,
      companyType: companyType ?? data.companyType,
      companySize: companySize ?? data.companySize,
      foundedYear: foundedYear ?? data.foundedYear,
      website: website ?? data.website,
      logo: logo ?? data.logo,
      coverImage: data.coverImage,
      email: email ?? data.email,
      phone: phone ?? data.phone,
      status: data.status ?? 'active',
      verified: data.verified ?? false,
      locations: locations ?? data.locations,
      importantFigures: importantFigures ?? data.importantFigures,
      policies: policies ?? data.policies,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locations = data.locations ?? const [];
    final figures = data.importantFigures ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'Company name',
          hint: 'e.g. Acme Corp',
          icon: Icons.apartment_rounded,
          initialValue: data.name,
          onChanged: (v) => onChanged(_copy(name: v)),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Description',
          hint: 'What does the company do?',
          icon: Icons.info_outline_rounded,
          initialValue: data.description,
          maxLines: 4,
          minLines: 3,
          onChanged: (v) => onChanged(_copy(description: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Industry',
          hint: 'e.g. Information Technology',
          icon: Icons.category_outlined,
          initialValue: data.industryType,
          onChanged: (v) => onChanged(_copy(industryType: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppDropdownField<CompanyType>(
          label: 'Company type',
          hint: 'Select company type',
          icon: Icons.business_center_outlined,
          items: CompanyType.values,
          value: data.companyType,
          labelBuilder: (v) => v.name,
          onChanged: (v) => onChanged(_copy(companyType: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Company size',
          hint: 'e.g. 51-200 employees',
          icon: Icons.groups_outlined,
          initialValue: data.companySize,
          onChanged: (v) => onChanged(_copy(companySize: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Founded year',
          icon: Icons.calendar_today_outlined,
          keyboardType: TextInputType.number,
          initialValue: data.foundedYear?.toString(),
          onChanged: (v) => onChanged(_copy(foundedYear: int.tryParse(v))),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Website',
          icon: Icons.language_rounded,
          keyboardType: TextInputType.url,
          initialValue: data.website,
          onChanged: (v) => onChanged(_copy(website: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Logo URL',
          icon: Icons.image_outlined,
          keyboardType: TextInputType.url,
          initialValue: data.logo,
          onChanged: (v) => onChanged(_copy(logo: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          initialValue: data.email,
          onChanged: (v) => onChanged(_copy(email: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Phone',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          initialValue: data.phone,
          onChanged: (v) => onChanged(_copy(phone: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppChipInputField(
          label: 'Policies',
          hint: 'e.g. Remote-friendly — press enter',
          values: data.policies ?? const [],
          onChanged: (v) => onChanged(_copy(policies: v)),
        ),
        SizedBox(height: AppSizes.s24),
        Text(
          'Locations',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColor.textPrimary),
        ),
        SizedBox(height: AppSizes.s12),
        for (int i = 0; i < locations.length; i++) ...[
          SectionCard(
            title: 'Location ${i + 1}',
            onRemove: () {
              final list = [...locations]..removeAt(i);
              onChanged(_copy(locations: list));
            },
            child: _CompanyLocationForm(
              item: locations[i],
              onChanged: (v) {
                final list = [...locations];
                list[i] = v;
                onChanged(_copy(locations: list));
              },
            ),
          ),
          SizedBox(height: AppSizes.s16),
        ],
        PrimaryButton(
          label: 'Add location',
          icon: Icons.add_rounded,
          isOutlined: true,
          width: double.infinity,
          onTap: () => onChanged(
            _copy(locations: [...locations, const CompanyLocation()]),
          ),
        ),
        SizedBox(height: AppSizes.s24),
        Text(
          'Important figures',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColor.textPrimary),
        ),
        SizedBox(height: AppSizes.s12),
        for (int i = 0; i < figures.length; i++) ...[
          SectionCard(
            title: 'Person ${i + 1}',
            onRemove: () {
              final list = [...figures]..removeAt(i);
              onChanged(_copy(importantFigures: list));
            },
            child: _ImportantFigureForm(
              item: figures[i],
              onChanged: (v) {
                final list = [...figures];
                list[i] = v;
                onChanged(_copy(importantFigures: list));
              },
            ),
          ),
          SizedBox(height: AppSizes.s16),
        ],
        PrimaryButton(
          label: 'Add important figure',
          icon: Icons.add_rounded,
          isOutlined: true,
          width: double.infinity,
          onTap: () => onChanged(
            _copy(importantFigures: [...figures, const ImportantFigure()]),
          ),
        ),
      ],
    );
  }
}

class _CompanyLocationForm extends StatelessWidget {
  const _CompanyLocationForm({required this.item, required this.onChanged});

  final CompanyLocation item;
  final ValueChanged<CompanyLocation> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'City',
          initialValue: item.city,
          onChanged: (v) => onChanged(CompanyLocation(city: v, state: item.state, country: item.country)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'State',
          initialValue: item.state,
          onChanged: (v) => onChanged(CompanyLocation(city: item.city, state: v, country: item.country)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Country',
          initialValue: item.country,
          onChanged: (v) => onChanged(CompanyLocation(city: item.city, state: item.state, country: v)),
        ),
      ],
    );
  }
}

class _ImportantFigureForm extends StatelessWidget {
  const _ImportantFigureForm({required this.item, required this.onChanged});

  final ImportantFigure item;
  final ValueChanged<ImportantFigure> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'Name',
          initialValue: item.name,
          onChanged: (v) => onChanged(ImportantFigure(staffId: item.staffId, name: v, designation: item.designation)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Designation',
          initialValue: item.designation,
          onChanged: (v) => onChanged(ImportantFigure(staffId: item.staffId, name: item.name, designation: v)),
        ),
      ],
    );
  }
}
