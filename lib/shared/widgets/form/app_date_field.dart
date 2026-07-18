import 'package:flutter/material.dart';
import 'package:hire_pro/core/constants/color_constants.dart';
import 'package:hire_pro/core/constants/sizes_constants.dart';

/// Generic labeled date picker field — opens the native date picker
/// and renders the chosen date in a read-only text field.
class AppDateField extends StatelessWidget {
  const AppDateField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.hint = 'Select date',
    this.icon = Icons.calendar_today_rounded,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.enabled = true,
  });

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final String? label;
  final String hint;
  final IconData icon;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? Function(DateTime?)? validator;
  final bool enabled;

  String _format(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pick(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1970),
      lastDate: lastDate ?? DateTime(2100),
    );
    if (picked != null) onChanged(picked);
  }

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
        FormField<DateTime>(
          key: ValueKey(value),
          initialValue: value,
          validator: validator,
          builder: (state) {
            return InkWell(
              borderRadius: BorderRadius.circular(AppSizes.r12),
              onTap: enabled
                  ? () async {
                      await _pick(context);
                    }
                  : null,
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(fontSize: 14, color: AppColor.textTertiary),
                  prefixIcon: Icon(icon, size: 20, color: AppColor.textSecondary),
                  suffixIcon: value != null && enabled
                      ? IconButton(
                          icon: Icon(Icons.close_rounded, size: 18, color: AppColor.textSecondary),
                          onPressed: () => onChanged(null),
                        )
                      : null,
                  filled: true,
                  fillColor: enabled
                      ? AppColor.textSecondary.withValues(alpha: 0.06)
                      : AppColor.textDisabled.withValues(alpha: 0.08),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: AppSizes.s14,
                    horizontal: AppSizes.s16,
                  ),
                  errorText: state.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                    borderSide: BorderSide(color: AppColor.primary, width: 1.5),
                  ),
                ),
                child: Text(
                  value != null ? _format(value!) : '',
                  style: TextStyle(fontSize: 14, color: AppColor.textPrimary),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
