import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../bloc/seller_bloc.dart';
import '../../bloc/seller_event.dart';
import '../../bloc/seller_state.dart';

class SellerProductsPage extends StatelessWidget {
  const SellerProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      body: SafeArea(
        child: BlocBuilder<SellerBloc, SellerState>(
          builder: (context, state) {
            if (state.status == SellerStatus.loading && state.products.isEmpty) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.charcoalInk),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Text('Sản phẩm', style: AppTextStyles.displayLarge.copyWith(fontSize: 28)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.pearlMist,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('${state.products.length} sp',
                            style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Product list
                Expanded(
                  child: state.products.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.inventory_2_outlined,
                                  size: 64, color: AppColors.stoneGray.withValues(alpha: 0.4)),
                              const SizedBox(height: 16),
                              Text('Chưa có sản phẩm nào',
                                  style: AppTextStyles.titleSmall.copyWith(color: AppColors.stoneGray)),
                              const SizedBox(height: 4),
                              Text('Thêm sản phẩm đầu tiên của bạn',
                                  style: AppTextStyles.bodySmall),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                          itemCount: state.products.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            final images = (product['images'] as List<dynamic>?) ?? [];
                            final imageUrl = images.isNotEmpty ? images.first as String : '';
                            final price = double.tryParse(product['price']?.toString() ?? '0') ?? 0;
                            final stock = product['stock'] as int? ?? 0;

                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.softWhite,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.pearlMist),
                              ),
                              child: Row(
                                children: [
                                  // Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: imageUrl.isNotEmpty
                                        ? Image.network(imageUrl,
                                            width: 70, height: 70, fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                _placeholder())
                                        : _placeholder(),
                                  ),
                                  const SizedBox(width: 14),
                                  // Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(product['name'] as String? ?? '',
                                            style: AppTextStyles.titleSmall,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 4),
                                        Text(CurrencyFormatter.formatVnd(price),
                                            style: AppTextStyles.bodySmall.copyWith(
                                                fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.inventory_outlined,
                                                size: 13, color: stock > 0 ? AppColors.stoneGray : Colors.red),
                                            const SizedBox(width: 4),
                                            Text(
                                              stock > 0 ? 'Kho: $stock' : 'Hết hàng',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: stock > 0 ? AppColors.stoneGray : Colors.red,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Actions
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert_rounded,
                                        color: AppColors.stoneGray, size: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                    color: AppColors.softWhite,
                                    onSelected: (value) {
                                      if (value == 'delete') {
                                        _confirmDelete(context, product['id'] as String);
                                      }
                                    },
                                    itemBuilder: (_) => [
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                            SizedBox(width: 8),
                                            Text('Xóa', style: TextStyle(color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.pearlMist,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.image_outlined, color: AppColors.stoneGray),
    );
  }

  void _confirmDelete(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa sản phẩm?'),
        content: const Text('Sản phẩm sẽ bị xóa vĩnh viễn.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              context.read<SellerBloc>().add(SellerProductDeleted(productId));
              Navigator.pop(context);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
