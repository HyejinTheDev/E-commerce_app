import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/product_card.dart';
import '../../../../../core/widgets/pill_chip.dart';
import '../../../../../core/widgets/search_bar_widget.dart';
import '../../bloc/search_bloc.dart';
import '../../bloc/search_event.dart';
import '../../bloc/search_state.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      body: SafeArea(
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                // ─── Search Bar ───
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: LucentSearchBar(
                      hint: 'Tìm kiếm sản phẩm...',
                      onChanged: (query) => context
                          .read<SearchBloc>()
                          .add(SearchQueryChanged(query)),
                    ),
                  ),
                ),

                // ─── Filter Chips ───
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.filters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return PillChip(
                            label: state.filters[index],
                            isSelected: state.selectedFilter == index,
                            onTap: () => context
                                .read<SearchBloc>()
                                .add(SearchFilterSelected(index)),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // ─── Results Count & Sort ───
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      children: [
                        Text(
                          state.query.isEmpty && state.selectedFilter == 0
                              ? 'Gợi ý cho bạn'
                              : '${state.totalResults} kết quả',
                          style: AppTextStyles.bodySmall,
                        ),
                        const Spacer(),
                        _SortButton(
                          currentLabel: state.sortLabel,
                          onSelected: (sortKey) => context
                              .read<SearchBloc>()
                              .add(SearchSortChanged(sortKey)),
                        ),
                      ],
                    ),
                  ),
                ),

                // ─── Loading ───
                if (state.status == SearchStatus.loading)
                  SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.charcoalInk),
                    ),
                  )
                else ...[
                  // ─── Empty State ───
                  if (state.results.isEmpty && state.status == SearchStatus.loaded)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off_rounded,
                                size: 64, color: AppColors.stoneGray.withValues(alpha: 0.5)),
                            const SizedBox(height: 16),
                            Text('Không tìm thấy sản phẩm',
                                style: AppTextStyles.titleSmall
                                    .copyWith(color: AppColors.stoneGray)),
                            const SizedBox(height: 4),
                            Text('Thử từ khóa khác hoặc bỏ bộ lọc',
                                style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    // ─── Product Grid ───
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                            final product = state.results[index];
                            return ProductCard(
                              imageUrl: product.imageUrl,
                              name: product.name,
                              brand: product.brand,
                              price: product.formattedPrice,
                              originalPrice: product.formattedOriginalPrice,
                              badge: product.badge,
                              onTap: () =>
                                  context.push('/product/${product.id}'),
                            );
                          },
                          childCount: state.results.length,
                        ),
                      ),
                    ),

                    // ─── Load More ───
                    if (state.hasMore)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(60, 24, 60, 100),
                          child: Center(
                            child: OutlinedButton(
                              onPressed: () => context
                                  .read<SearchBloc>()
                                  .add(const SearchLoadMore()),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.pearlMist,
                                side: BorderSide.none,
                                shape: const StadiumBorder(),
                              ),
                              child:
                                  Text('Xem Thêm', style: AppTextStyles.titleSmall),
                            ),
                          ),
                        ),
                      ),
                  ],
                ],

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Sort dropdown button
class _SortButton extends StatelessWidget {
  final String currentLabel;
  final ValueChanged<String> onSelected;

  const _SortButton({required this.currentLabel, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      offset: const Offset(0, 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: AppColors.softWhite,
      itemBuilder: (context) => [
        _buildItem('newest', 'Mới nhất', Icons.schedule_rounded),
        _buildItem('price_asc', 'Giá tăng dần', Icons.arrow_upward_rounded),
        _buildItem('price_desc', 'Giá giảm dần', Icons.arrow_downward_rounded),
        _buildItem('best_rated', 'Đánh giá cao', Icons.star_rounded),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Sắp xếp: ', style: AppTextStyles.bodySmall),
          Text(currentLabel,
              style: AppTextStyles.titleSmall.copyWith(fontSize: 13)),
          Icon(Icons.keyboard_arrow_down_rounded,
              size: 18, color: AppColors.charcoalInk),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildItem(String value, String label, IconData icon) {
    final isActive = currentLabel == label;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18,
              color: isActive ? AppColors.charcoalInk : AppColors.stoneGray),
          const SizedBox(width: 10),
          Text(label,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: AppColors.charcoalInk,
              )),
          if (isActive) ...[
            const Spacer(),
            Icon(Icons.check_rounded, size: 16, color: AppColors.charcoalInk),
          ],
        ],
      ),
    );
  }
}
