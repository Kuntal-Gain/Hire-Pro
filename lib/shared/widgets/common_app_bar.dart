import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hire_pro/core/constants/color_constants.dart';
import 'package:hire_pro/core/constants/icons_constants.dart';
import 'package:hire_pro/core/constants/sizes_constants.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.showBackButton = true,
    this.centerTitle = false,
    this.height = kToolbarHeight,
    this.backgroundColor,
  });

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool centerTitle;
  final double height;
  final Color? backgroundColor;

  static const double _leadingSlotWidth = 48;

  @override
  Widget build(BuildContext context) {
    final canPop = context.canPop();
    final showLeading = leading != null || (showBackButton && canPop);

    return Material(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              const SizedBox(width: 8),

              SizedBox(
                width: _leadingSlotWidth,
                child: showLeading
                    ? (leading ?? _buildBackButton(context))
                    : null,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Align(
                  alignment: centerTitle
                      ? Alignment.center
                      : Alignment.centerLeft,
                  child: Text(
                    title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              if (actions != null && actions!.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < actions!.length; i++) ...[
                      if (i != 0) SizedBox(width: AppSizes.p6),
                      actions![i],
                    ],
                  ],
                )
              else
                const SizedBox(width: _leadingSlotWidth),

              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: context.pop,
      child: Container(
        padding: EdgeInsets.all(AppSizes.p6),
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(AppSizes.r8),
        ),
        child: const Icon(
          AppIcons.leftIcon,
          size: AppSizes.s36,
          color: AppColor.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
