import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Order card showing order info, status badge, and action buttons
class OrderCard extends StatelessWidget {
  final String orderId;
  final String date;
  final String status;
  final String? deliveryEstimate;
  final String? totalAmount;
  final int itemCount;
  final VoidCallback? onTap;
  final VoidCallback? onTrack;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.date,
    required this.status,
    this.deliveryEstimate,
    this.totalAmount,
    this.itemCount = 0,
    this.onTap,
    this.onTrack,
  });

  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'in transit':
      case 'delivered':
        return AppColors.sageGreen;
      case 'processing':
        return AppColors.warmSand;
      case 'cancelled':
        return AppColors.terracottaBlush;
      default:
        return AppColors.stoneGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.softWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.charcoalInk.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(orderId, style: AppTextStyles.titleSmall),
                Text(date, style: AppTextStyles.bodySmall),
              ],
            ),
            const SizedBox(height: 12),
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _statusColor,
                ),
              ),
            ),
            if (deliveryEstimate != null) ...[
              const SizedBox(height: 10),
              Text(deliveryEstimate!, style: AppTextStyles.titleSmall),
            ],
            if (totalAmount != null) ...[
              const SizedBox(height: 6),
              Text(
                '$itemCount items — $totalAmount',
                style: AppTextStyles.bodySmall,
              ),
            ],
            if (onTrack != null) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: onTrack,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pearlMist,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    'Track Order',
                    style: AppTextStyles.titleSmall,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
