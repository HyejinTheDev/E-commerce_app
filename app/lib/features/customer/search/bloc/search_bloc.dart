import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/mock_data.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc()
      : super(SearchState(
          filters: MockData.searchFilters,
          results: MockData.featuredProducts,
          totalResults: MockData.featuredProducts.length,
        )) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchFilterSelected>(_onFilterSelected);
    on<SearchLoadMore>(_onLoadMore);
  }

  Future<void> _onQueryChanged(
      SearchQueryChanged event, Emitter<SearchState> emit) async {
    emit(state.copyWith(status: SearchStatus.loading, query: event.query));

    await Future.delayed(const Duration(milliseconds: 300));

    final filtered = MockData.featuredProducts
        .where((p) =>
            p.name.toLowerCase().contains(event.query.toLowerCase()) ||
            p.brand.toLowerCase().contains(event.query.toLowerCase()))
        .toList();

    emit(state.copyWith(
      status: SearchStatus.loaded,
      results: filtered,
      totalResults: filtered.length,
    ));
  }

  void _onFilterSelected(
      SearchFilterSelected event, Emitter<SearchState> emit) {
    emit(state.copyWith(selectedFilter: event.index));
  }

  Future<void> _onLoadMore(
      SearchLoadMore event, Emitter<SearchState> emit) async {
    // Simulate loading more
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(hasMore: false));
  }
}
