import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/pill_chip.dart';
import '../../../../core/widgets/search_bar_widget.dart';
import '../../search/bloc/search_bloc.dart';
import '../../search/bloc/search_event.dart';
import '../../search/bloc/search_state.dart';

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
                      hint: 'Search products...',
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

                // ─── Results Count ───
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      children: [
                        Text('${state.totalResults} results',
                            style: AppTextStyles.bodySmall),
                        const Spacer(),
                        Text('Sort by: ', style: AppTextStyles.bodySmall),
                        Text('Relevance',
                            style:
                                AppTextStyles.titleSmall.copyWith(fontSize: 13)),
                        const Icon(Icons.keyboard_arrow_down_rounded,
                            size: 18, color: AppColors.charcoalInk),
                      ],
                    ),
                  ),
                ),

                // ─── Loading ───
                if (state.status == SearchStatus.loading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.charcoalInk),
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
                                Text('Load More', style: AppTextStyles.titleSmall),
                          ),
                        ),
                      ),
                    ),
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
