import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../bloc/seller_bloc.dart';
import '../../bloc/seller_event.dart';
import '../../bloc/seller_state.dart';
import 'add_product_page.dart';

class SellerProductsPage extends StatelessWidget {
  const SellerProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<SellerBloc>(),
                child: const AddProductPage(),
              ),
            ),
          );
        },
        backgroundColor: AppColors.charcoalInk,
        child: Icon(Icons.add, color: AppColors.vanillaCream),
      ),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Text(l.productsLabel,
                          style: AppTextStyles.displayLarge
                              .copyWith(fontSize: 28)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.pearlMist,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(l.nProductsShort(state.products.length),
                            style: AppTextStyles.bodySmall
                                .copyWith(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: state.products.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.inventory_2_outlined,
                                  size: 64,
                                  color:
                                      AppColors.stoneGray.withValues(alpha: 0.4)),
                              const SizedBox(height: 16),
                              Text(l.noProducts,
                                  style: AppTextStyles.titleSmall
                                      .copyWith(color: AppColors.stoneGray)),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<SellerBloc>(),
                                        child: const AddProductPage(),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(l.addFirstProduct),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          color: AppColors.charcoalInk,
                          onRefresh: () async {
                            context
                                .read<SellerBloc>()
                                .add(const SellerProductsLoaded());
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                          },
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                            itemCount: state.products.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final product = state.products[index];
                              return _ProductCard(product: product);
                            },
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final images = (product['images'] as List<dynamic>?) ?? [];
    final name = product['name'] as String? ?? '';
    final price = double.tryParse(product['price']?.toString() ?? '0') ?? 0;
    final stock = product['stock'] as int? ?? 0;
    final productId = product['id'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.softWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.pearlMist),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: images.isNotEmpty
                ? Image.network(images.first as String,
                    width: 80, height: 80, fit: BoxFit.cover,
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
                Text(name,
                    style: AppTextStyles.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(CurrencyFormatter.formatVnd(price),
                    style: AppTextStyles.bodySmall
                        .copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: stock > 0
                            ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
                            : const Color(0xFFEF5350).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        l.stock2(stock),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: stock > 0
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFEF5350),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Delete
          IconButton(
            icon: Icon(Icons.delete_outline,
                color: AppColors.stoneGray, size: 20),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(l.deleteProduct),
                  content: Text(l.deleteProductConfirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context
                            .read<SellerBloc>()
                            .add(SellerProductDeleted(productId));
                      },
                      child: Text(l.deleteAction,
                          style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.pearlMist,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.image_outlined, color: AppColors.stoneGray),
    );
  }
}
