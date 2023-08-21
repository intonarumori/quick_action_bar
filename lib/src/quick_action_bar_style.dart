// Custom theme for custom components:
// https://www.youtube.com/watch?v=8-szcYzFVao&t=291s
import 'package:flutter/material.dart';

class QuickActionBarStyle extends ThemeExtension<QuickActionBarStyle> {
  final Color selectionBackgroundColor;
  final Color textColor;
  final Color disabledTextColor;

  QuickActionBarStyle({
    Color? selectionBackgroundColor,
    Color? textColor,
    Color? disabledTextColor,
  })  : selectionBackgroundColor = selectionBackgroundColor ?? Colors.grey,
        textColor = textColor ?? Colors.black,
        disabledTextColor = disabledTextColor ?? Colors.grey[200]!;

  @override
  ThemeExtension<QuickActionBarStyle> copyWith({
    Color? selectionBackgroundColor,
    Color? textColor,
    Color? disabledTextColor,
  }) =>
      QuickActionBarStyle(
        selectionBackgroundColor: selectionBackgroundColor ?? this.selectionBackgroundColor,
        textColor: textColor ?? this.textColor,
        disabledTextColor: disabledTextColor ?? this.disabledTextColor,
      );

  @override
  ThemeExtension<QuickActionBarStyle> lerp(ThemeExtension<QuickActionBarStyle>? other, double t) {
    if (other is! QuickActionBarStyle) {
      return this;
    }
    return QuickActionBarStyle(
      selectionBackgroundColor:
          Color.lerp(selectionBackgroundColor, other.selectionBackgroundColor, t) ??
              selectionBackgroundColor,
      textColor: Color.lerp(textColor, other.textColor, t) ?? textColor,
      disabledTextColor:
          Color.lerp(disabledTextColor, other.disabledTextColor, t) ?? disabledTextColor,
    );
  }
}
