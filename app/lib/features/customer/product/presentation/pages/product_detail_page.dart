import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
      body: BlocListener<ProductDetailBloc, ProductDetailState>(
        listenWhen: (previous, current) => previous.errorMessage != current.errorMessage && current.errorMessage != null,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.terracottaBlush,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
          if (state.status == ProductDetailStatus.loading ||
              state.product == null) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.charcoalInk),
            );
          }

          final product = state.product!;
          final displayImages = product.images.isNotEmpty
              ? product.images
              : (product.imageUrl.isNotEmpty ? [product.imageUrl] : <String>[]);
          final currentImageIndex = state.selectedImage < displayImages.length
              ? state.selectedImage
              : 0;

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
                      title: const Text('Chi Tiết Sản Phẩm'),
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
                              clipBehavior: Clip.antiAlias,
                              child: displayImages.isNotEmpty
                                  ? Image.network(
                                      displayImages[currentImageIndex],
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.warmSand,
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (_, __, ___) => Center(
                                        child: Icon(Icons.image_outlined,
                                            size: 60,
                                            color: AppColors.stoneGray),
                                      ),
                                    )
                                  : Center(
                                      child: Icon(Icons.image_outlined,
                                          size: 60, color: AppColors.stoneGray),
                                    ),
                            ),
                            if (displayImages.length > 1) ...[
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(displayImages.length,
                                    (index) {
                                  final isActive = currentImageIndex == index;
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
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.network(
                                        displayImages[index],
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            Icon(Icons.image_outlined,
                                                size: 24,
                                                color: AppColors.stoneGray),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
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
                            Text('Màu sắc', style: AppTextStyles.titleMedium),
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
                            Text('Kích cỡ', style: AppTextStyles.titleMedium),
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
                            Text('Mô tả',
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
                                Text('Đánh giá',
                                    style: AppTextStyles.titleMedium),
                                const SizedBox(width: 10),
                                Icon(Icons.star_rounded,
                                    color: AppColors.warmSand, size: 18),
                                const SizedBox(width: 4),
                                Text(product.rating.toStringAsFixed(1),
                                    style: AppTextStyles.titleSmall),
                                const SizedBox(width: 4),
                                Text('(${product.reviewCount} đánh giá)',
                                    style: AppTextStyles.bodySmall),
                                const Spacer(),
                                TextButton.icon(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (ctx) => _WriteReviewSheet(
                                        onSubmit: (rating, comment) {
                                          context.read<ProductDetailBloc>().add(
                                                ProductReviewSubmitted(
                                                    rating: rating,
                                                    comment: comment),
                                              );
                                          Navigator.pop(ctx);
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit_outlined, size: 16),
                                  label: const Text('Viết đánh giá'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.charcoalInk,
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                            if (state.isSubmittingReview)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.warmSand),
                                ),
                              ),
                            const SizedBox(height: 16),
                            if (product.reviews.isEmpty)
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('Chưa có đánh giá nào cho sản phẩm này.',
                                    style: TextStyle(color: AppColors.stoneGray)),
                              )
                            else
                              ...product.reviews.map((review) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _ReviewCard(
                                    name: review.userName,
                                    rating: review.rating,
                                    comment: review.comment ?? '',
                                  ),
                                );
                              }),
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
                          Text('Tổng', style: AppTextStyles.bodySmall),
                          Text(product.formattedPrice,
                              style: AppTextStyles.priceLarge),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: PillButton(
                                label: 'Giỏ',
                                icon: Icons.shopping_bag_outlined,
                                isPrimary: false,
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
                                      content: Text('${product.name} đã được thêm vào giỏ hàng'),
                                      backgroundColor: AppColors.charcoalInk,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: PillButton(
                                label: 'Mua Ngay',
                                isPrimary: true,
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
                                  GoRouter.of(context).go('/cart');
                                },
                              ),
                            ),
                          ],
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
                child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    style: TextStyle(
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
          if (comment.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(comment, style: AppTextStyles.bodyMedium),
          ],
        ],
      ),
    );
  }
}

class _WriteReviewSheet extends StatefulWidget {
  final Function(int rating, String comment) onSubmit;
  const _WriteReviewSheet({required this.onSubmit});

  @override
  State<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<_WriteReviewSheet> {
  int _rating = 5;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.vanillaCream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Viết đánh giá', style: AppTextStyles.titleLarge),
              const SizedBox(height: 24),
              const Center(child: Text('Chất lượng sản phẩm')),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () => setState(() => _rating = index + 1),
                    icon: Icon(
                      index < _rating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: AppColors.warmSand,
                      size: 40,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Hãy chia sẻ nhận xét của bạn về sản phẩm...',
                  filled: true,
                  fillColor: AppColors.softWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PillButton(
                label: 'Gửi Đánh Giá',
                isFullWidth: true,
                onPressed: () {
                  widget.onSubmit(_rating, _commentController.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
