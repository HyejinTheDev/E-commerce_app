import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Lucent Design System — Typography
/// Inter font family with tight letter-spacing for editorial feel
class AppTextStyles {
  AppTextStyles._();

  // ─── Display / Headlines ───
  /// Large page titles — "Lucent" brand, hero headings
  static TextStyle get displayLarge => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.64, // -2%
        color: AppColors.charcoalInk,
      );

  /// Section headings — "Featured", "Categories"
  static TextStyle get headlineMedium => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.44,
        color: AppColors.charcoalInk,
      );

  // ─── Titles ───
  /// Product names, menu items
  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoalInk,
      );

  /// Card titles, form labels
  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoalInk,
      );

  /// Small titles, chip labels
  static TextStyle get titleSmall => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.charcoalInk,
      );

  // ─── Body ───
  /// Main body text
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: AppColors.stoneGray,
      );

  /// Secondary body text
  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.stoneGray,
      );

  /// Captions, metadata
  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.stoneGray,
      );

  // ─── Labels ───
  /// Uppercase category tags
  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.stoneGray,
      );

  /// Small labels, badges
  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        color: AppColors.stoneGray,
      );

  // ─── Special ───
  /// Prices — bold and prominent
  static TextStyle get priceLarge => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.charcoalInk,
      );

  static TextStyle get priceMedium => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.charcoalInk,
      );

  /// Strikethrough old price
  static TextStyle get priceStrikethrough => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.stoneGray,
        decoration: TextDecoration.lineThrough,
      );

  /// Button text
  static TextStyle get button => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      );
}
