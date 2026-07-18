import 'package:flutter/material.dart';
import 'package:hire_pro/core/constants/color_constants.dart';
import 'package:hire_pro/core/constants/sizes_constants.dart';

class StepIndicatorItem {
  const StepIndicatorItem({required this.label, this.isOptional = false});

  final String label;
  final bool isOptional;
}

/// Generic fixed-width numbered step indicator for multi-step flows —
/// filled circles with step numbers connected by progress lines, and
/// a label under each. Steps ahead of [currentStep] appear inactive;
/// completed steps show a check mark.
class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  final List<StepIndicatorItem> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final leftStep = i ~/ 2;
          final isDone = leftStep < currentStep;
          return Expanded(
            child: Container(
              height: 2,

              color: isDone ? AppColor.primary : AppColor.border,
            ),
          );
        }

        final index = i ~/ 2;
        final step = steps[index];
        final isActive = index == currentStep;
        final isDone = index < currentStep;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone || isActive
                    ? AppColor.primary
                    : AppColor.surfaceElevated,
                border: Border.all(
                  color: isDone || isActive
                      ? AppColor.primary
                      : AppColor.border,
                  width: 1.4,
                ),
              ),
              child: isDone
                  ? const Icon(
                      Icons.check_rounded,
                      size: 17,
                      color: AppColor.white,
                    )
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isActive
                            ? AppColor.white
                            : AppColor.textTertiary,
                      ),
                    ),
            ),
            SizedBox(height: AppSizes.s6),
            SizedBox(
              width: 64,
              child: Text(
                step.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? AppColor.primary : AppColor.textTertiary,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
