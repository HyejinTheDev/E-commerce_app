import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/mock_data.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeLoaded>(_onLoaded);
    on<HomeCategorySelected>(_onCategorySelected);
  }

  Future<void> _onLoaded(HomeLoaded event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    emit(state.copyWith(
      status: HomeStatus.loaded,
      featuredProducts: MockData.featuredProducts,
      categories: MockData.categoryFilters,
    ));
  }

  void _onCategorySelected(
      HomeCategorySelected event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedCategory: event.index));

    // Filter products by category
    if (event.index == 0) {
      emit(state.copyWith(featuredProducts: MockData.featuredProducts));
    } else {
      final category = state.categories[event.index];
      final filtered = MockData.featuredProducts
          .where((p) => p.category == category)
          .toList();
      emit(state.copyWith(
        featuredProducts:
            filtered.isEmpty ? MockData.featuredProducts : filtered,
      ));
    }
  }
}
