import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Lucent Design System — App Theme
/// Soft Minimalism: warm beige canvas, pill-shaped buttons, whisper-soft shadows
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.vanillaCream,
      canvasColor: AppColors.vanillaCream,

      // ─── Color Scheme ───
      colorScheme: ColorScheme.light(
        primary: AppColors.charcoalInk,
        onPrimary: AppColors.softWhite,
        secondary: AppColors.warmSand,
        onSecondary: AppColors.charcoalInk,
        tertiary: AppColors.sageGreen,
        error: AppColors.terracottaBlush,
        surface: AppColors.softWhite,
        onSurface: AppColors.charcoalInk,
        onSurfaceVariant: AppColors.stoneGray,
        outline: AppColors.pearlMist,
        outlineVariant: AppColors.divider,
      ),

      // ─── Typography ───
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.64,
          color: AppColors.charcoalInk,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.44,
          color: AppColors.charcoalInk,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoalInk,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoalInk,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.charcoalInk,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.6,
          color: AppColors.stoneGray,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: AppColors.stoneGray,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.stoneGray,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: AppColors.stoneGray,
        ),
      ),

      // ─── App Bar ───
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.vanillaCream,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.44,
          color: AppColors.charcoalInk,
        ),
        iconTheme: IconThemeData(color: AppColors.charcoalInk, size: 24),
      ),

      // ─── Buttons ───
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.charcoalInk,
          foregroundColor: AppColors.softWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.charcoalInk,
          side: BorderSide(color: AppColors.pearlMist),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.charcoalInk,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ─── Inputs ───
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.pearlMist,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.warmSand,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.stoneGray,
        ),
      ),

      // ─── Cards ───
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.softWhite,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),

      // ─── Bottom Nav ───
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.softWhite,
        selectedItemColor: AppColors.charcoalInk,
        unselectedItemColor: AppColors.stoneGray,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // ─── Chips ───
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.pearlMist,
        selectedColor: AppColors.charcoalInk,
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.charcoalInk,
        ),
        side: BorderSide.none,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // ─── Divider ───
      dividerTheme: DividerThemeData(
        color: AppColors.pearlMist,
        thickness: 1,
        space: 0,
      ),

      // ─── Bottom Sheet ───
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.softWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }

  // ─── Dark Theme ───
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      canvasColor: const Color(0xFF121212),

      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFF5F0E8),
        onPrimary: Color(0xFF1A1A1A),
        secondary: Color(0xFFBFA98A),
        onSecondary: Color(0xFF1A1A1A),
        tertiary: Color(0xFF81C784),
        error: Color(0xFFEF9A9A),
        surface: Color(0xFF1E1E1E),
        onSurface: Color(0xFFF5F0E8),
        onSurfaceVariant: Color(0xFF9E9E9E),
        outline: Color(0xFF3A3A3A),
        outlineVariant: Color(0xFF2A2A2A),
      ),

      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32, fontWeight: FontWeight.w600,
          letterSpacing: -0.64, color: const Color(0xFFF5F0E8),
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 22, fontWeight: FontWeight.w600,
          letterSpacing: -0.44, color: const Color(0xFFF5F0E8),
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFFF5F0E8),
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFFF5F0E8),
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFFF5F0E8),
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w400, height: 1.6,
          color: const Color(0xFF9E9E9E),
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w400, height: 1.5,
          color: const Color(0xFF9E9E9E),
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xFF9E9E9E),
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5,
          color: const Color(0xFF9E9E9E),
        ),
      ),

      appBarTheme: AppBarTheme(
        centerTitle: false, elevation: 0, scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFF121212),
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 22, fontWeight: FontWeight.w600,
          letterSpacing: -0.44, color: const Color(0xFFF5F0E8),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF5F0E8), size: 24),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF5F0E8),
          foregroundColor: const Color(0xFF1A1A1A),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF1E1E1E),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1A1A1A),
        selectedItemColor: Color(0xFFF5F0E8),
        unselectedItemColor: Color(0xFF6E6E6E),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A2A2A), thickness: 1, space: 0,
      ),
    );
  }
}
