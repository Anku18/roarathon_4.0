import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.bg,
      canvasColor: AppColors.bg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.coral,
        onPrimary: AppColors.cream,
        secondary: AppColors.ink,
        onSecondary: AppColors.cream,
        surface: AppColors.bg,
        onSurface: AppColors.ink,
        error: AppColors.deep,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      dividerColor: AppColors.line,
    );

    final text = GoogleFonts.bricolageGrotesqueTextTheme(base.textTheme).apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    );

    return base.copyWith(
      textTheme: text,
      splashColor: AppColors.blush,
      highlightColor: AppColors.blush.withValues(alpha: 0.4),
    );
  }

  static TextStyle font({
    double size = 14,
    FontWeight weight = FontWeight.w600,
    Color color = AppColors.ink,
    double letterSpacing = 0,
    double? height,
  }) {
    return GoogleFonts.bricolageGrotesque(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}
