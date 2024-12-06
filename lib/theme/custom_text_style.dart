import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension on TextStyle {
  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }

  TextStyle get openSans {
    return copyWith(
      fontFamily: 'Open Sans',
    );
  }
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
  // Body text style
  static TextStyle get bodyLargePoppins =>
      theme.textTheme.bodyLarge!.poppins.copyWith(
        fontSize: 16.0,
      );

  static get bodyLargePoppins_l => theme.textTheme.bodyLarge!.poppins;
  static TextStyle get bodySmallGray700 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray700,
        fontSize: 11.0,
        fontWeight: FontWeight.w400,
      );

  // Label text style
  static TextStyle get labelMediumGreen900 =>
      theme.textTheme.labelMedium!.copyWith(
        color: appTheme.green900,
      );

  static TextStyle get labelMediumPrimaryContainer =>
      theme.textTheme.labelMedium!.copyWith(
        color: theme.colorScheme.primaryContainer,
      );

  // Title text style
  static TextStyle get titleMediumOnErrorContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onErrorContainer,
      );

  static TextStyle get titleMediumOnPrimaryContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 19.0,
        fontWeight: FontWeight.w700,
      );
}
