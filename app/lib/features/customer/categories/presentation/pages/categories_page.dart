import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/search_bar_widget.dart';
import '../../bloc/categories_bloc.dart';
import '../../bloc/categories_bloc_types.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  static const _iconMap = {
    'checkroom': Icons.checkroom_rounded,
    'sports_gymnastics': Icons.sports_gymnastics_rounded,
    'shopping_bag': Icons.shopping_bag_outlined,
    'watch': Icons.watch_outlined,
    'home': Icons.home_outlined,
    'face': Icons.face_retouching_natural_outlined,
    'devices': Icons.devices_outlined,
    'fitness_center': Icons.fitness_center_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      body: SafeArea(
        child: BlocBuilder<CategoriesBloc, CategoriesState>(
          builder: (context, state) {
            if (state.status == CategoriesStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.charcoalInk),
              );
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  backgroundColor: AppColors.vanillaCream,
                  elevation: 0,
                  title: Text('Danh Mục',
                      style: AppTextStyles.headlineMedium),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: LucentSearchBar(
                        hint: 'Tìm danh mục...', readOnly: true),
                  ),
                ),

                // Featured Banner
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                            colors: [Color(0xFFD4C8B8), Color(0xFFE8DDD0)]),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Women's Fashion",
                              style: AppTextStyles.titleLarge
                                  .copyWith(fontSize: 22)),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.charcoalInk,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Text('Khám Phá',
                                style: TextStyle(
                                    color: AppColors.softWhite,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Category Grid
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.3,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final cat = state.categories[index];
                        final icon =
                            _iconMap[cat.iconName] ?? Icons.category_outlined;
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.softWhite,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.charcoalInk
                                    .withValues(alpha: 0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.pearlMist,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(icon,
                                    size: 28, color: AppColors.charcoalInk),
                              ),
                              const SizedBox(height: 10),
                              Text(cat.name, style: AppTextStyles.titleSmall),
                            ],
                          ),
                        );
                      },
                      childCount: state.categories.length,
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
