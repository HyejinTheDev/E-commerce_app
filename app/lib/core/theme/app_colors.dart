import 'package:flutter/material.dart';
import '../../main.dart' show themeNotifier;

/// Lucent Design System — Color Palette (Adaptive)
/// Returns dark variants when dark mode is active
class AppColors {
  AppColors._();

  static bool get _isDark => themeNotifier.isDarkMode;

  // ─── Primary Palette ───
  /// Page background
  static Color get vanillaCream =>
      _isDark ? const Color(0xFF121212) : const Color(0xFFF5F1E9);

  /// Primary text, headings, button fills
  static Color get charcoalInk =>
      _isDark ? const Color(0xFFF5F0E8) : const Color(0xFF1A1A1A);

  /// Accent for interactive elements
  static Color get warmSand =>
      _isDark ? const Color(0xFFBFA98A) : const Color(0xFFC5B9A8);

  /// Secondary surfaces, dividers
  static Color get pearlMist =>
      _isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE8E2D8);

  /// Card surfaces, elevated containers
  static Color get softWhite =>
      _isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFDFCFA);

  // ─── Text ───
  /// Secondary text, captions
  static Color get stoneGray =>
      _isDark ? const Color(0xFF9E9E9E) : const Color(0xFF8A8278);

  // ─── Semantic ───
  static const Color sageGreen = Color(0xFF7D9B76);
  static const Color terracottaBlush = Color(0xFFC47A5A);

  // ─── Surface Hierarchy ───
  static Color get surfaceContainerLow =>
      _isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFDF9EF);
  static Color get surfaceContainer =>
      _isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F4E7);
  static Color get surfaceContainerHigh =>
      _isDark ? const Color(0xFF252525) : const Color(0xFFF2EEDF);
  static Color get surfaceContainerHighest =>
      _isDark ? const Color(0xFF303030) : const Color(0xFFECE8D7);

  // ─── Utility ───
  static const Color transparent = Colors.transparent;
  static Color get shadowColor =>
      _isDark ? const Color(0x33000000) : const Color(0x0A1A1A1A);
  static Color get divider =>
      _isDark ? const Color(0xFF3A3A3A) : const Color(0x26BDBAA9);
}
