import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/product_card.dart';
import '../../../../../core/widgets/pill_chip.dart';
import '../../../../../core/widgets/search_bar_widget.dart';
import '../../../../../core/widgets/section_header.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';
import '../../bloc/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.charcoalInk),
              );
            }

            return CustomScrollView(
              slivers: [
                // ─── Top Bar ───
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Lucent', style: AppTextStyles.displayLarge),
                        Row(
                          children: [
                            _IconBtn(Icons.notifications_none_rounded,
                                onTap: () {}),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.pearlMist,
                              child: Icon(Icons.person_outline_rounded,
                                  color: AppColors.charcoalInk, size: 22),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ─── Search Bar ───
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: LucentSearchBar(
                      readOnly: true,
                      onTap: () => context.go('/search'),
                    ),
                  ),
                ),

                // ─── Hero Banner ───
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFD4C8B8), Color(0xFFE8DDD0)],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 20,
                            top: 0,
                            bottom: 0,
                            child: Icon(Icons.diamond_outlined,
                                size: 120,
                                color:
                                    AppColors.softWhite.withValues(alpha: 0.3)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Bộ Sưu Tập\nXuân',
                                    style: AppTextStyles.displayLarge
                                        .copyWith(height: 1.1)),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.charcoalInk,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text('Mua Ngay',
                                      style: TextStyle(
                                          color: AppColors.softWhite,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ─── Category Chips ───
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return PillChip(
                            label: state.categories[index],
                            isSelected: state.selectedCategory == index,
                            onTap: () => context
                                .read<HomeBloc>()
                                .add(HomeCategorySelected(index)),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // ─── Featured Section ───
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
                    child: SectionHeader(title: 'Nổi Bật', onActionTap: () {}),
                  ),
                ),

                // ─── Product Grid ───
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.58,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = state.featuredProducts[index];
                        return ProductCard(
                          imageUrl: product.imageUrl,
                          name: product.name,
                          brand: product.brand,
                          price: product.formattedPrice,
                          originalPrice: product.formattedOriginalPrice,
                          badge: product.badge,
                          onTap: () => context.push('/product/${product.id}'),
                        );
                      },
                      childCount: state.featuredProducts.length,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _IconBtn(this.icon, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.pearlMist,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 22, color: AppColors.charcoalInk),
      ),
    );
  }
}
