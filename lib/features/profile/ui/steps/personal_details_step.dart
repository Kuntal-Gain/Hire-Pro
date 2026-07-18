import 'package:flutter/material.dart';
import 'package:hire_pro/core/constants/server_constants.dart';
import 'package:hire_pro/core/constants/sizes_constants.dart';
import 'package:hire_pro/core/network/client_manager.dart';
import 'package:hire_pro/features/profile/model/profile_request_model.dart';
import 'package:hire_pro/shared/widgets/form/app_date_field.dart';
import 'package:hire_pro/shared/widgets/form/app_dropdown_field.dart';
import 'package:hire_pro/shared/widgets/form/app_text_field.dart';
import 'package:hire_pro/shared/widgets/form/app_upload_field.dart';

class PersonalDetailsStep extends StatelessWidget {
  const PersonalDetailsStep({
    super.key,
    required this.data,
    required this.onChanged,
  });

  final PersonalDetailsRequestModel data;
  final ValueChanged<PersonalDetailsRequestModel> onChanged;

  @override
  Widget build(BuildContext context) {
    final location = data.location ?? LocationRequestModel();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppUploadField(
          label: 'Profile photo',
          hint: 'Upload a profile picture',
          icon: Icons.person_rounded,
          bucket: Buckets.profile,
          pathPrefix: SupabaseManager.currentUserId ?? 'anonymous',
          allowedExtensions: const ['png', 'jpg', 'jpeg'],
          fileName: data.profileImage?.split('-').last,
          previewUrl: data.profileImage,
          onUploaded: (url) => onChanged(_copy(data, profileImage: url)),
          onRemove: () => onChanged(_copy(data, profileImage: '')),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Full name',
          hint: 'e.g. Kuntal Gain',
          icon: Icons.badge_outlined,
          initialValue: data.fullName,
          onChanged: (v) => onChanged(_copy(data, fullName: v)),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Headline',
          hint: 'e.g. Flutter Developer',
          icon: Icons.work_outline_rounded,
          initialValue: data.headline,
          onChanged: (v) => onChanged(_copy(data, headline: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Bio',
          hint: 'Tell us about yourself',
          icon: Icons.info_outline_rounded,
          initialValue: data.bio,
          maxLines: 4,
          minLines: 3,
          onChanged: (v) => onChanged(_copy(data, bio: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Phone',
          hint: 'e.g. +91 9876543210',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          initialValue: data.phone,
          onChanged: (v) => onChanged(_copy(data, phone: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Email',
          hint: 'e.g. you@example.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          initialValue: data.email,
          onChanged: (v) => onChanged(_copy(data, email: v)),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Required';
            if (!v.contains('@')) return 'Enter a valid email';
            return null;
          },
        ),
        SizedBox(height: AppSizes.s16),
        AppDropdownField<String>(
          label: 'Gender',
          hint: 'Select gender',
          icon: Icons.wc_rounded,
          items: const ['Male', 'Female', 'Other'],
          value: data.gender,
          labelBuilder: (v) => v,
          onChanged: (v) => onChanged(_copy(data, gender: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppDateField(
          label: 'Date of birth',
          value: data.dateOfBirth,
          lastDate: DateTime.now(),
          onChanged: (v) => onChanged(_copy(data, dateOfBirth: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'City',
          icon: Icons.location_city_rounded,
          initialValue: location.city,
          onChanged: (v) => onChanged(
            _copy(
              data,
              location: LocationRequestModel(
                city: v,
                state: location.state,
                country: location.country,
              ),
            ),
          ),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'State',
          icon: Icons.map_outlined,
          initialValue: location.state,
          onChanged: (v) => onChanged(
            _copy(
              data,
              location: LocationRequestModel(
                city: location.city,
                state: v,
                country: location.country,
              ),
            ),
          ),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Country',
          icon: Icons.public_rounded,
          initialValue: location.country,
          onChanged: (v) => onChanged(
            _copy(
              data,
              location: LocationRequestModel(
                city: location.city,
                state: location.state,
                country: v,
              ),
            ),
          ),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Portfolio',
          icon: Icons.language_rounded,
          keyboardType: TextInputType.url,
          initialValue: data.portfolio,
          onChanged: (v) => onChanged(_copy(data, portfolio: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'LinkedIn',
          icon: Icons.link_rounded,
          keyboardType: TextInputType.url,
          initialValue: data.linkedin,
          onChanged: (v) => onChanged(_copy(data, linkedin: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'GitHub',
          icon: Icons.code_rounded,
          keyboardType: TextInputType.url,
          initialValue: data.github,
          onChanged: (v) => onChanged(_copy(data, github: v)),
        ),
        SizedBox(height: AppSizes.s16),
        AppTextField(
          label: 'Website',
          icon: Icons.web_rounded,
          keyboardType: TextInputType.url,
          initialValue: data.website,
          onChanged: (v) => onChanged(_copy(data, website: v)),
        ),
      ],
    );
  }

  PersonalDetailsRequestModel _copy(
    PersonalDetailsRequestModel d, {
    String? fullName,
    String? profileImage,
    String? headline,
    String? bio,
    String? phone,
    String? email,
    String? gender,
    DateTime? dateOfBirth,
    LocationRequestModel? location,
    String? portfolio,
    String? linkedin,
    String? github,
    String? website,
  }) {
    return PersonalDetailsRequestModel(
      fullName: fullName ?? d.fullName,
      profileImage: profileImage ?? d.profileImage,
      headline: headline ?? d.headline,
      bio: bio ?? d.bio,
      phone: phone ?? d.phone,
      email: email ?? d.email,
      gender: gender ?? d.gender,
      dateOfBirth: dateOfBirth ?? d.dateOfBirth,
      location: location ?? d.location,
      portfolio: portfolio ?? d.portfolio,
      linkedin: linkedin ?? d.linkedin,
      github: github ?? d.github,
      website: website ?? d.website,
    );
  }
}
