import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/repositories/product_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductRepository _productRepository;
  int _currentPage = 1;

  SearchBloc(this._productRepository)
      : super(const SearchState(
          filters: ['All', 'Clothing', 'Under \$100', 'Best Rated', 'New Arrivals'],
        )) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchFilterSelected>(_onFilterSelected);
    on<SearchLoadMore>(_onLoadMore);
  }

  Future<void> _onQueryChanged(
      SearchQueryChanged event, Emitter<SearchState> emit) async {
    emit(state.copyWith(status: SearchStatus.loading, query: event.query));
    _currentPage = 1;

    try {
      final response = await _productRepository.getProducts(
        search: event.query.isNotEmpty ? event.query : null,
        page: 1,
        limit: 20,
      );

      emit(state.copyWith(
        status: SearchStatus.loaded,
        results: response.products,
        totalResults: response.total,
        hasMore: response.hasMore,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.error,
        results: [],
        totalResults: 0,
      ));
    }
  }

  void _onFilterSelected(
      SearchFilterSelected event, Emitter<SearchState> emit) {
    emit(state.copyWith(selectedFilter: event.index));
  }

  Future<void> _onLoadMore(
      SearchLoadMore event, Emitter<SearchState> emit) async {
    if (!state.hasMore) return;

    _currentPage++;
    try {
      final response = await _productRepository.getProducts(
        search: state.query.isNotEmpty ? state.query : null,
        page: _currentPage,
        limit: 20,
      );

      emit(state.copyWith(
        results: [...state.results, ...response.products],
        totalResults: response.total,
        hasMore: response.hasMore,
      ));
    } catch (e) {
      _currentPage--;
    }
  }
}
