import 'package:flutter/material.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Section header with title and optional "See All" action
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;
  final bool hideAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
    this.hideAction = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultAction = AppLocalizations.of(context)?.seeAll ?? 'Xem tất cả';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.headlineMedium),
        if (!hideAction)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText ?? defaultAction,
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.warmSand,
              ),
            ),
          ),
      ],
    );
  }
}
