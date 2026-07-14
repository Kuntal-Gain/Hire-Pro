import 'package:flutter/material.dart';
import 'package:hire_pro/core/constants/color_constants.dart';
import 'package:hire_pro/core/constants/sizes_constants.dart';


/// Reusable primary CTA button — handles loading, disabled, icon,
/// outlined variant, and full-width sizing so no screen re-implements
/// button boilerplate.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double height;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final IconData? icon;
  final bool iconTrailing;
  final double iconSize;
  final double iconSpacing;
  final bool isLoading;
  final bool isOutlined;
  final bool isDisabled;
  final EdgeInsetsGeometry? padding;
  final double elevation;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.height = 52,
    this.borderRadius = 12,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w700,
    this.icon,
    this.iconTrailing = false,
    this.iconSize = 18,
    this.iconSpacing = 8,
    this.isLoading = false,
    this.isOutlined = false,
    this.isDisabled = false,
    this.padding,
    this.elevation = 0,
  });

  bool get _isInteractive => !isDisabled && !isLoading && onTap != null;

  @override
  Widget build(BuildContext context) {
    final bg = isOutlined
        ? Colors.transparent
        : (backgroundColor ?? AppColor.primary);

    // final resolvedBg = _isInteractive ? bg : _disabledBg;
    final resolvedText = _isInteractive
        ? (textColor ??
              (isOutlined ? AppColor.primary : AppColor.white))
        : AppColor.textDisabled;
    final resolvedBorder = isOutlined
        ? (borderColor ?? (isDisabled ? AppColor.border : AppColor.primary))
        : null;

    return Padding(
      padding: EdgeInsets.all(AppSizes.p4),
      child: SizedBox(
        width: width,
        height: height,
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(borderRadius),
          elevation: _isInteractive ? elevation : 0,
          child: InkWell(
            onTap: _isInteractive ? onTap : () {},
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: resolvedText.withValues(alpha: 0.1),
            child: Container(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: resolvedBorder != null
                    ? Border.all(color: resolvedBorder, width: 1.4)
                    : null,
              ),
              alignment: Alignment.center,
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColor.white),
                      ),
                    )
                  : _buildContent(resolvedText),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color resolvedText) {
    final textWidget = Text(
      label,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: resolvedText,
      ),
      overflow: TextOverflow.ellipsis,
    );

    if (icon == null) return textWidget;

    final iconWidget = Icon(icon, size: iconSize, color: resolvedText);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: iconTrailing
          ? [textWidget, SizedBox(width: iconSpacing), iconWidget]
          : [iconWidget, SizedBox(width: iconSpacing), textWidget],
    );
  }

  Color get _disabledBg => isOutlined
      ? Colors.transparent
      : AppColor.textDisabled.withValues(alpha: 0.3);
}

/*

// Basic
PrimaryButton(label: 'Apply Now', onTap: () {})

// Loading state (e.g. during Riverpod AsyncNotifier submission)
PrimaryButton(label: 'Sign In', onTap: _submit, isLoading: state.isLoading)

// Outlined variant
PrimaryButton(label: 'Cancel', onTap: () {}, isOutlined: true)

// With icon, custom colors, full width
PrimaryButton(
  label: 'Upload Resume',
  icon: Icons.upload_rounded,
  onTap: _pickFile,
  width: double.infinity,
  backgroundColor: AppColor.accentBlue,
)

// Disabled (e.g. form invalid)
PrimaryButton(label: 'Continue', onTap: null, isDisabled: true)

*/