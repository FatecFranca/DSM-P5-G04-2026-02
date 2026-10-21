import 'package:flutter/material.dart';
import '../models/prediction_result.dart';

class AppColors {
  static const primary = Color(0xFF3F3DB8);
  static const primaryDark = Color(0xFF2B2A8F);
  static const accent = Color(0xFF7C5CE0);
  static const background = Color(0xFFF4F5FD);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF1B1D3D);
  static const textSecondary = Color(0xFF6B7090);
  static const border = Color(0xFFE2E4F3);
  static const success = Color(0xFF15803D);
  static const successBg = Color(0xFFDDF7E6);
  static const danger = Color(0xFFE11D48);
  static const dangerBg = Color(0xFFFFE3E8);
  static const shadow = Color(0x143F3DB8);
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
}

class AppTheme {
  static ThemeData get light {
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: AppColors.surface,
    );
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c, width: w),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        hintStyle:
            const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        border: border(AppColors.border),
        enabledBorder: border(AppColors.border),
        focusedBorder: border(AppColors.primary, 1.6),
        errorBorder: border(AppColors.danger),
        focusedErrorBorder: border(AppColors.danger, 1.6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xB33F3DB8),
          disabledForegroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

/// Cores/textos associados a cada nível de risco.
extension RiskLevelStyle on RiskLevel {
  bool get isRisk => this == RiskLevel.emRisco;
  String get label => isRisk ? 'Em risco' : 'Sem risco';
  String get headline => isRisk ? 'Em risco de evasão' : 'Baixo risco de evasão';
  Color get color => isRisk ? AppColors.danger : AppColors.success;
  Color get background => isRisk ? AppColors.dangerBg : AppColors.successBg;
  IconData get icon =>
      isRisk ? Icons.priority_high_rounded : Icons.check_rounded;
}
