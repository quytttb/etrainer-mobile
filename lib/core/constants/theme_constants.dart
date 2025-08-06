import 'package:flutter/material.dart';

class ThemeConstants {
  // Primary Color Palette
  static const Color primaryColor = Color(0xFF2196F3); // Blue
  static const Color primaryDarkColor = Color(0xFF1976D2);
  static const Color primaryLightColor = Color(0xFFBBDEFB);
  
  // Secondary Color Palette
  static const Color secondaryColor = Color(0xFF4CAF50); // Green
  static const Color secondaryDarkColor = Color(0xFF388E3C);
  static const Color secondaryLightColor = Color(0xFFC8E6C9);
  
  // Accent Colors
  static const Color accentColor = Color(0xFFFF9800); // Orange
  static const Color warningColor = Color(0xFFFF5722); // Red Orange
  static const Color errorColor = Color(0xFFF44336); // Red
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color infoColor = Color(0xFF2196F3); // Blue
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
  
  // Learning Progress Colors
  static const Color beginnerColor = Color(0xFF4CAF50); // Green
  static const Color intermediateColor = Color(0xFFFF9800); // Orange
  static const Color advancedColor = Color(0xFFF44336); // Red
  static const Color completedColor = Color(0xFF2196F3); // Blue
  
  // Quiz/Practice Colors
  static const Color correctAnswerColor = Color(0xFF4CAF50);
  static const Color incorrectAnswerColor = Color(0xFFF44336);
  static const Color selectedAnswerColor = Color(0xFF2196F3);
  static const Color neutralAnswerColor = Color(0xFFE0E0E0);
  
  // Text Colors - Light Theme
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightTextHint = Color(0xFFBDBDBD);
  static const Color lightTextDisabled = Color(0xFFBDBDBD);
  
  // Text Colors - Dark Theme
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkTextHint = Color(0xFF666666);
  static const Color darkTextDisabled = Color(0xFF666666);
  
  // Background Colors - Light Theme
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF5F5F5);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightScaffold = Color(0xFFFAFAFA);
  
  // Background Colors - Dark Theme
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkScaffold = Color(0xFF121212);
  
  // Border and Divider Colors
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color darkBorder = Color(0xFF3C3C3C);
  static const Color lightDivider = Color(0xFFE0E0E0);
  static const Color darkDivider = Color(0xFF3C3C3C);
  
  // Shadow Colors
  static const Color lightShadow = Color(0x1F000000);
  static const Color darkShadow = Color(0x3F000000);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryDarkColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [successColor, Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient warningGradient = LinearGradient(
    colors: [warningColor, Color(0xFFE64A19)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusExtraLarge = 24.0;
  
  // Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double spacingXXLarge = 48.0;
  
  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;
  
  // Font Sizes
  static const double fontSizeCaption = 12.0;
  static const double fontSizeBody2 = 14.0;
  static const double fontSizeBody1 = 16.0;
  static const double fontSizeSubtitle2 = 14.0;
  static const double fontSizeSubtitle1 = 16.0;
  static const double fontSizeHeadline6 = 20.0;
  static const double fontSizeHeadline5 = 24.0;
  static const double fontSizeHeadline4 = 32.0;
  static const double fontSizeHeadline3 = 48.0;
  
  // Elevation
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  static const double elevationMaximum = 16.0;
  
  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
}
