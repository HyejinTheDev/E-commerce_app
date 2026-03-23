import 'package:flutter/material.dart';

/// Lucent Design System — Color Palette
/// Based on "The Luminous Curator" Soft Minimalism theme
class AppColors {
  AppColors._();

  // ─── Primary Palette ───
  /// Page background — warm beige foundation
  static const Color vanillaCream = Color(0xFFF5F1E9);

  /// Primary text, headings, button fills
  static const Color charcoalInk = Color(0xFF1A1A1A);

  /// Accent for interactive elements, highlights, selections
  static const Color warmSand = Color(0xFFC5B9A8);

  /// Secondary surfaces, card backgrounds, dividers
  static const Color pearlMist = Color(0xFFE8E2D8);

  /// Card surfaces, elevated containers
  static const Color softWhite = Color(0xFFFDFCFA);

  // ─── Text ───
  /// Secondary text, captions, metadata
  static const Color stoneGray = Color(0xFF8A8278);

  // ─── Semantic ───
  /// Success states, in-stock, positive
  static const Color sageGreen = Color(0xFF7D9B76);

  /// Sale badges, warnings, attention
  static const Color terracottaBlush = Color(0xFFC47A5A);

  // ─── Surface Hierarchy ───
  static const Color surfaceContainerLow = Color(0xFFFDF9EF);
  static const Color surfaceContainer = Color(0xFFF7F4E7);
  static const Color surfaceContainerHigh = Color(0xFFF2EEDF);
  static const Color surfaceContainerHighest = Color(0xFFECE8D7);

  // ─── Utility ───
  static const Color transparent = Colors.transparent;
  static const Color shadowColor = Color(0x0A1A1A1A); // 4% opacity charcoal
  static const Color divider = Color(0x26BDBAA9); // 15% outline-variant
}
