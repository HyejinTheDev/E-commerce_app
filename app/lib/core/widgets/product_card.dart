import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Product card for 2-column grids
/// Displays product image, name, brand, and price
class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String brand;
  final String price;
  final String? originalPrice;
  final String? badge;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.brand,
    required this.price,
    this.originalPrice,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          AspectRatio(
            aspectRatio: 0.85,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.pearlMist,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: imageUrl.startsWith('http')
                        ? Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.warmSand,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 40,
                                color: AppColors.stoneGray,
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 40,
                              color: AppColors.stoneGray,
                            ),
                          ),
                  ),
                  if (badge != null)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.terracottaBlush,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Product name
          Text(
            name,
            style: AppTextStyles.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          // Brand
          Text(
            brand,
            style: AppTextStyles.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          // Price row
          Row(
            children: [
              Text(price, style: AppTextStyles.priceMedium),
              if (originalPrice != null) ...[
                const SizedBox(width: 6),
                Text(originalPrice!, style: AppTextStyles.priceStrikethrough),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
