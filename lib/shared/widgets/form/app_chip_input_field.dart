import 'package:flutter/material.dart';
import 'package:hire_pro/core/constants/color_constants.dart';
import 'package:hire_pro/core/constants/sizes_constants.dart';

/// Generic free-text tag/chip input — type a value and press enter or
/// the add button to add it as a chip. Backs list<String> fields like
/// skills, job titles, preferred locations, technologies, etc.
class AppChipInputField extends StatefulWidget {
  const AppChipInputField({
    super.key,
    required this.values,
    required this.onChanged,
    this.label,
    this.hint = 'Type and press enter',
  });

  final List<String> values;
  final ValueChanged<List<String>> onChanged;
  final String? label;
  final String hint;

  @override
  State<AppChipInputField> createState() => _AppChipInputFieldState();
}

class _AppChipInputFieldState extends State<AppChipInputField> {
  final _ctrl = TextEditingController();

  void _add() {
    final text = _ctrl.text.trim();
    if (text.isEmpty || widget.values.contains(text)) return;
    widget.onChanged([...widget.values, text]);
    _ctrl.clear();
  }

  void _remove(String value) {
    widget.onChanged(widget.values.where((e) => e != value).toList());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColor.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.s8),
        ],
        TextField(
          controller: _ctrl,
          onSubmitted: (_) => _add(),
          style: TextStyle(fontSize: 14, color: AppColor.textPrimary),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(fontSize: 14, color: AppColor.textTertiary),
            suffixIcon: IconButton(
              icon: Icon(Icons.add_rounded, color: AppColor.primary),
              onPressed: _add,
            ),
            filled: true,
            fillColor: AppColor.textSecondary.withValues(alpha: 0.06),
            contentPadding: EdgeInsets.symmetric(
              vertical: AppSizes.s14,
              horizontal: AppSizes.s16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.r12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.r12),
              borderSide: BorderSide(color: AppColor.primary, width: 1.5),
            ),
          ),
        ),
        if (widget.values.isNotEmpty) ...[
          SizedBox(height: AppSizes.s10),
          Wrap(
            spacing: AppSizes.s8,
            runSpacing: AppSizes.s8,
            children: widget.values
                .map(
                  (v) => Chip(
                    label: Text(v, style: TextStyle(fontSize: 12.5, color: AppColor.primaryDark)),
                    backgroundColor: AppColor.primaryContainer,
                    deleteIcon: const Icon(Icons.close_rounded, size: 16),
                    deleteIconColor: AppColor.primaryDark,
                    onDeleted: () => _remove(v),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

/// Generic multi-select chip group — for choosing several items from a
/// fixed set (e.g. employment types, work modes) without free text entry.
class AppMultiSelectChips<T> extends StatelessWidget {
  const AppMultiSelectChips({
    super.key,
    required this.items,
    required this.selected,
    required this.onChanged,
    required this.labelBuilder,
    this.label,
  });

  final List<T> items;
  final List<T> selected;
  final ValueChanged<List<T>> onChanged;
  final String Function(T item) labelBuilder;
  final String? label;

  void _toggle(T item) {
    final isSelected = selected.contains(item);
    onChanged(
      isSelected
          ? selected.where((e) => e != item).toList()
          : [...selected, item],
    );
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
        Wrap(
          spacing: AppSizes.s8,
          runSpacing: AppSizes.s8,
          children: items.map((item) {
            final isSelected = selected.contains(item);
            return GestureDetector(
              onTap: () => _toggle(item),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.s14,
                  vertical: AppSizes.s10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColor.primary
                      : AppColor.textSecondary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(AppSizes.r20),
                  border: Border.all(
                    color: isSelected ? AppColor.primary : AppColor.border,
                  ),
                ),
                child: Text(
                  labelBuilder(item),
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColor.white : AppColor.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
