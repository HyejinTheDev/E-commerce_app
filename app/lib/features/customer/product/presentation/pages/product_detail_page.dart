import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/pill_button.dart';
import '../../../../../core/widgets/pill_chip.dart';
import '../../../cart/bloc/cart_bloc.dart';
import '../../../cart/bloc/cart_event.dart';
import '../../bloc/product_detail_bloc.dart';
import '../../bloc/product_detail_event.dart';
import '../../bloc/product_detail_state.dart';

class ProductDetailPage extends StatelessWidget {
  final String? productId;

  const ProductDetailPage({super.key, this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          if (state.status == ProductDetailStatus.loading ||
              state.product == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.charcoalInk),
            );
          }

          final product = state.product!;

          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // ─── App Bar ───
                    SliverAppBar(
                      floating: true,
                      backgroundColor: AppColors.vanillaCream,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      title: const Text('Product Detail'),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.share_outlined),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),

                    // ─── Product Image Gallery ───
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              height: 360,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.pearlMist,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Icon(Icons.image_outlined,
                                    size: 60, color: AppColors.stoneGray),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (index) {
                                final isActive = state.selectedImage == index;
                                return GestureDetector(
                                  onTap: () => context
                                      .read<ProductDetailBloc>()
                                      .add(ProductImageSelected(index)),
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.pearlMist,
                                      borderRadius: BorderRadius.circular(12),
                                      border: isActive
                                          ? Border.all(
                                              color: AppColors.charcoalInk,
                                              width: 2)
                                          : null,
                                    ),
                                    child: const Icon(Icons.image_outlined,
                                        size: 24, color: AppColors.stoneGray),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ─── Product Info ───
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name,
                                style: AppTextStyles.titleLarge
                                    .copyWith(fontSize: 24)),
                            const SizedBox(height: 4),
                            Text(product.brand,
                                style: AppTextStyles.bodyMedium),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(product.formattedPrice,
                                    style: AppTextStyles.priceLarge),
                                if (product.formattedOriginalPrice !=
                                    null) ...[
                                  const SizedBox(width: 10),
                                  Text(product.formattedOriginalPrice!,
                                      style:
                                          AppTextStyles.priceStrikethrough),
                                ],
                                if (product.badge != null) ...[
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.terracottaBlush,
                                      borderRadius:
                                          BorderRadius.circular(100),
                                    ),
                                    child: Text(product.badge!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ─── Color Selector ───
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Color', style: AppTextStyles.titleMedium),
                            const SizedBox(height: 12),
                            Row(
                              children: List.generate(
                                  product.colors.length, (index) {
                                final isActive = state.selectedColor == index;
                                return GestureDetector(
                                  onTap: () => context
                                      .read<ProductDetailBloc>()
                                      .add(ProductColorSelected(index)),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color:
                                          Color(product.colors[index]),
                                      shape: BoxShape.circle,
                                      border: isActive
                                          ? Border.all(
                                              color: AppColors.charcoalInk,
                                              width: 2.5)
                                          : Border.all(
                                              color: AppColors.pearlMist,
                                              width: 1),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ─── Size Selector ───
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Size', style: AppTextStyles.titleMedium),
                            const SizedBox(height: 12),
                            Row(
                              children: List.generate(
                                  product.sizes.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: PillChip(
                                    label: product.sizes[index],
                                    isSelected: state.selectedSize == index,
                                    onTap: () => context
                                        .read<ProductDetailBloc>()
                                        .add(ProductSizeSelected(index)),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ─── Description ───
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description',
                                style: AppTextStyles.titleMedium),
                            const SizedBox(height: 8),
                            Text(product.description,
                                style: AppTextStyles.bodyLarge),
                          ],
                        ),
                      ),
                    ),

                    // ─── Reviews ───
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Reviews',
                                    style: AppTextStyles.titleMedium),
                                const SizedBox(width: 10),
                                const Icon(Icons.star_rounded,
                                    color: AppColors.warmSand, size: 18),
                                const SizedBox(width: 4),
                                Text('${product.rating}',
                                    style: AppTextStyles.titleSmall),
                                const SizedBox(width: 4),
                                Text('(${product.reviewCount} reviews)',
                                    style: AppTextStyles.bodySmall),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _ReviewCard(
                              name: 'Emma W.',
                              rating: 5,
                              comment: 'Absolutely love the quality! Fits perfectly.',
                            ),
                            const SizedBox(height: 12),
                            _ReviewCard(
                              name: 'James K.',
                              rating: 4,
                              comment: 'Great item, very comfortable. Would recommend.',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  ],
                ),
              ),

              // ─── Bottom Action Bar ───
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                decoration: BoxDecoration(
                  color: AppColors.softWhite,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.charcoalInk.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Total', style: AppTextStyles.bodySmall),
                          Text(product.formattedPrice,
                              style: AppTextStyles.priceLarge),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: PillButton(
                          label: 'Add to Cart',
                          icon: Icons.shopping_bag_outlined,
                          isFullWidth: true,
                          onPressed: () {
                            context.read<CartBloc>().add(CartItemAdded(
                                  productId: product.id,
                                  name: product.name,
                                  brand: product.brand,
                                  price: product.price,
                                  imageUrl: product.imageUrl,
                                  selectedSize:
                                      product.sizes[state.selectedSize],
                                  selectedColor:
                                      product.colors[state.selectedColor],
                                ));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} added to cart'),
                                backgroundColor: AppColors.charcoalInk,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;
  const _ReviewCard(
      {required this.name, required this.rating, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.softWhite,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.pearlMist,
                child: Text(name[0],
                    style: const TextStyle(
                        color: AppColors.charcoalInk,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 10),
              Text(name, style: AppTextStyles.titleSmall),
              const Spacer(),
              Row(
                children: List.generate(
                    5,
                    (i) => Icon(
                        i < rating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 16,
                        color: AppColors.warmSand)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(comment, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
