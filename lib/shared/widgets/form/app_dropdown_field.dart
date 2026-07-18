import 'package:flutter/material.dart';
import 'package:hire_pro/core/constants/color_constants.dart';
import 'package:hire_pro/core/constants/sizes_constants.dart';

/// Generic labeled dropdown field. [labelBuilder] maps an item of type
/// [T] to its display string, so this can back enum dropdowns, string
/// dropdowns, or anything else.
class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.labelBuilder,
    this.label,
    this.hint,
    this.icon,
    this.validator,
    this.enabled = true,
  });

  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String Function(T item) labelBuilder;
  final String? label;
  final String? hint;
  final IconData? icon;
  final String? Function(T?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColor.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.s8),
        ],
        DropdownButtonFormField<T>(
          initialValue: value,
          validator: validator,
          onChanged: enabled ? onChanged : null,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColor.textSecondary),
          style: TextStyle(fontSize: 14, color: AppColor.textPrimary),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(labelBuilder(item), overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14, color: AppColor.textTertiary),
            prefixIcon: icon != null
                ? Icon(icon, size: 20, color: AppColor.textSecondary)
                : null,
            filled: true,
            fillColor: enabled
                ? AppColor.textSecondary.withValues(alpha: 0.06)
                : AppColor.textDisabled.withValues(alpha: 0.08),
            contentPadding: EdgeInsets.symmetric(
              vertical: AppSizes.s14,
              horizontal: AppSizes.s16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.r12),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.r12),
              borderSide: BorderSide(color: AppColor.error, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.r12),
              borderSide: BorderSide(color: AppColor.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
