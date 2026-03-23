import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Pill-shaped button — Primary (charcoal fill) or Secondary (pearl mist fill)
class PillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isFullWidth;
  final IconData? icon;
  final double verticalPadding;

  const PillButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isPrimary = true,
    this.isFullWidth = false,
    this.icon,
    this.verticalPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    final button = MaterialButton(
      onPressed: onPressed,
      color: isPrimary ? AppColors.charcoalInk : AppColors.pearlMist,
      elevation: 0,
      highlightElevation: 0,
      shape: const StadiumBorder(),
      padding: EdgeInsets.symmetric(
        horizontal: 28,
        vertical: verticalPadding,
      ),
      child: Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20,
              color: isPrimary ? AppColors.softWhite : AppColors.charcoalInk,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: isPrimary ? AppColors.softWhite : AppColors.charcoalInk,
            ),
          ),
        ],
      ),
    );

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
