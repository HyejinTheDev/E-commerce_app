import 'package:flutter/material.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../theme/app_colors.dart';

/// Pill-shaped search bar with magnifying glass icon
class LucentSearchBar extends StatelessWidget {
  final String? hint;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool readOnly;

  const LucentSearchBar({
    super.key,
    this.hint,
    this.onTap,
    this.onChanged,
    this.controller,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultHint = AppLocalizations.of(context)?.searchProducts ?? 'Tìm kiếm sản phẩm...';
    return GestureDetector(
      onTap: readOnly ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.pearlMist,
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              size: 22,
              color: AppColors.stoneGray,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: readOnly
                  ? Text(
                      hint ?? defaultHint,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.stoneGray,
                      ),
                    )
                  : TextField(
                      controller: controller,
                      onChanged: onChanged,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.charcoalInk,
                      ),
                      decoration: InputDecoration(
                        hintText: hint ?? defaultHint,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: AppColors.stoneGray,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        filled: false,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
