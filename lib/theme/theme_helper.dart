import 'package:flutter/material.dart';
import '../core/app_export.dart';

String _appTheme = "LightCode";
LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.
/// ignore_for_file: must_be_immutable
class ThemeHelper {
  // A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'LightCode': LightCodeColors()
  };

  // A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'LightCode': ColorSchemes.lightCodeColorScheme
  };

  /// Changes the app theme to [_newTheme].
  void changeTheme(String _newTheme) {
    _appTheme = _newTheme;
  }

  /// Returns the LightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.onPrimaryContainer,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26.h),
          ),
          elevation: 0,
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.onError,
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: colorScheme.onErrorContainer,
      ),
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: colorScheme.onErrorContainer,
          fontSize: 18.0,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: appTheme.gray700,
          fontSize: 14.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: appTheme.black900,
          fontSize: 12.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w300,
        ),
        displayLarge: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontSize: 53.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: TextStyle(
          color: colorScheme.onErrorContainer,
          fontSize: 25.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        labelLarge: TextStyle(
          color: appTheme.blueGray900,
          fontSize: 12.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: colorScheme.onPrimary,
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: appTheme.blueGray900,
          fontSize: 16.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: colorScheme.primary,
          fontSize: 14.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light(
    primary: Color(0xFF8C8AAD),
    primaryContainer: Color(0xFF6572B0),
    secondaryContainer: Color(0xFFB2B2B2),
    errorContainer: Color(0xFF5A3B48),
    onError: Color(0xFFADE6D6),
    onErrorContainer: Color(0xFFF0E017),
    onPrimary: Color(0xFF757103),
    onPrimaryContainer: Color(0xFFFFFFFF),
  );
}

/// Class containing custom colors for a lightCode theme.
// Black
class LightCodeColors {
  Color get black900 => Color(0xFF000000);
  // BlueGray
  Color get blueGray900 => Color(0xFF313131);
  // Gray
  Color get gray50 => Color(0xFFFBFBFB);
  Color get gray500 => Color(0xFFA3A3A3);
  Color get gray700 => Color(0xFF757575);
  // Green
  Color get green900 => Color(0xFF225701);
  Color get greenA100 => Color(0xFFC8FFC3);
  // Red
  Color get red50 => Color(0xFFFDEDF4);
  Color get red500 => Color(0xFFFF4444);
  // Teal
  Color get teal100 => Color(0xFFA4F7C7);
  Color get teal800 => Color(0xFF079845);
  // Yellow
  Color get yellow500 => Color(0xFFFFF733);
}
