import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  // Screen Size
  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  // Width Fraction
  double widthFraction(double fraction) {
    return screenWidth * fraction;
  }

  // Height Fraction
  double heightFraction(double fraction) {
    return screenHeight * fraction;
  }

  // Safe Area
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  // Keyboard Height
  double get keyboardHeight {
    return MediaQuery.viewInsetsOf(this).bottom;
  }

  // Theme
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;
}
