import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../product/domain/repositories/product_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository _productRepository;

  HomeBloc(this._productRepository) : super(const HomeState()) {
    on<HomeLoaded>(_onLoaded);
    on<HomeCategorySelected>(_onCategorySelected);
  }

  Future<void> _onLoaded(HomeLoaded event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final response = await _productRepository.getProducts(limit: 10);
      // Extract unique category names for filter chips
      final categoryNames = <String>{'All'};
      for (final p in response.products) {
        if (p.category.isNotEmpty) categoryNames.add(p.category);
      }

      emit(state.copyWith(
        status: HomeStatus.loaded,
        featuredProducts: response.products,
        categories: categoryNames.toList(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Failed to load products: $e',
      ));
    }
  }

  Future<void> _onCategorySelected(
      HomeCategorySelected event, Emitter<HomeState> emit) async {
    emit(state.copyWith(selectedCategory: event.index));

    try {
      if (event.index == 0) {
        // "All" selected — reload without filter
        final response = await _productRepository.getProducts(limit: 10);
        emit(state.copyWith(featuredProducts: response.products));
      } else {
        // Filter by searching for category name
        final category = state.categories[event.index];
        final response = await _productRepository.getProducts(
          search: category,
          limit: 10,
        );
        emit(state.copyWith(featuredProducts: response.products));
      }
    } catch (e) {
      // Keep current products on error
    }
  }
}
