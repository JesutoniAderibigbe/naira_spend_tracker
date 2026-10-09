import 'package:flutter/material.dart';

/// Colours from the Figma "Tokens" frame (see design/tokens.json).
///
/// Generated in workshop step 5 by an agent reading Figma through MCP, then
/// reviewed by a human. Widgets should read colours from the theme, not from
/// this class directly.
abstract final class AppColors {
  static const Color primary = Color(0xFF008751); // brand/primary
  static const Color onPrimary = Color(0xFFFFFFFF); // brand/on-primary
  static const Color secondary = Color(0xFFF2A900); // brand/secondary
  static const Color background = Color(0xFFF7F9F7); // surface/background
  static const Color card = Color(0xFFE3F1E8); // surface/card
  static const Color textMuted = Color(0xFF5B6B62); // text/muted
}

/// Light and dark themes built from the Figma tokens.
///
/// The tokens name Inter as the font. Add it with the google_fonts package or
/// as an asset if you want it; until then the platform font is used with the
/// token sizes and weights.
abstract final class AppTheme {
  static ThemeData get light => _build(
    ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.card,
      secondary: AppColors.secondary,
      surface: AppColors.background,
      onSurfaceVariant: AppColors.textMuted,
    ),
  );

  static ThemeData get dark => _build(
    ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      secondary: AppColors.secondary,
    ),
  );

  static ThemeData _build(ColorScheme colors) {
    final base = ThemeData(colorScheme: colors);
    final text = base.textTheme;

    return base.copyWith(
      scaffoldBackgroundColor: colors.surface,
      textTheme: text.copyWith(
        // headline/amount
        headlineMedium: text.headlineMedium?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        // title/section
        titleMedium: text.titleMedium?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        // body/default
        bodyMedium: text.bodyMedium?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      cardTheme: const CardThemeData(elevation: 0),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
    );
  }
}
