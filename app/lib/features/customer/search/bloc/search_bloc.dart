import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../product/domain/repositories/product_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

import '../domain/repositories/search_history_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductRepository _productRepository;
  final SearchHistoryRepository _historyRepository;
  int _currentPage = 1;

  SearchBloc(this._productRepository, this._historyRepository)
      : super(const SearchState(
          filters: ['Tất cả', 'Dưới 500K', 'Đánh giá cao', 'Mới nhất'],
        )) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchFilterSelected>(_onFilterSelected);
    on<SearchSortChanged>(_onSortChanged);
    on<SearchLoadMore>(_onLoadMore);
    on<SearchHistoryLoaded>(_onHistoryLoaded);
    on<SearchHistoryRemoved>(_onHistoryRemoved);
    on<SearchHistoryCleared>(_onHistoryCleared);
  }

  Future<void> _onHistoryLoaded(
      SearchHistoryLoaded event, Emitter<SearchState> emit) async {
    final history = await _historyRepository.getSearchHistory();
    emit(state.copyWith(history: history));
  }

  Future<void> _onHistoryRemoved(
      SearchHistoryRemoved event, Emitter<SearchState> emit) async {
    await _historyRepository.removeSearchQuery(event.query);
    final history = await _historyRepository.getSearchHistory();
    emit(state.copyWith(history: history));
  }

  Future<void> _onHistoryCleared(
      SearchHistoryCleared event, Emitter<SearchState> emit) async {
    await _historyRepository.clearSearchHistory();
    emit(state.copyWith(history: []));
  }

  // Convert current filter index to API params
  String? _sortFromFilter(int filterIndex) {
    switch (filterIndex) {
      case 2: return 'best_rated';
      case 3: return 'newest';
      default: return state.sortKey;
    }
  }

  double? _maxPriceFromFilter(int filterIndex) {
    if (filterIndex == 1) return 500000;
    return null;
  }

  Future<void> _fetchProducts(Emitter<SearchState> emit, {
    String? query,
    int? filterIndex,
    String? sortKey,
  }) async {
    final effectiveQuery = query ?? state.query;
    final effectiveFilter = filterIndex ?? state.selectedFilter;
    final effectiveSort = sortKey ?? _sortFromFilter(effectiveFilter);

    emit(state.copyWith(status: SearchStatus.loading));
    _currentPage = 1;

    try {
      final response = await _productRepository.getProducts(
        search: effectiveQuery.isNotEmpty ? effectiveQuery : null,
        page: 1,
        limit: 20,
        sort: effectiveSort,
        maxPrice: _maxPriceFromFilter(effectiveFilter),
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

  Future<void> _onQueryChanged(
      SearchQueryChanged event, Emitter<SearchState> emit) async {
    emit(state.copyWith(query: event.query));
    if (event.query.trim().isNotEmpty) {
      await _historyRepository.addSearchQuery(event.query);
      final history = await _historyRepository.getSearchHistory();
      emit(state.copyWith(history: history));
    }
    await _fetchProducts(emit, query: event.query);
  }

  Future<void> _onFilterSelected(
      SearchFilterSelected event, Emitter<SearchState> emit) async {
    emit(state.copyWith(selectedFilter: event.index));
    await _fetchProducts(emit, filterIndex: event.index);
  }

  Future<void> _onSortChanged(
      SearchSortChanged event, Emitter<SearchState> emit) async {
    final label = _sortLabelMap[event.sortKey] ?? 'Mới nhất';
    emit(state.copyWith(sortKey: event.sortKey, sortLabel: label));
    await _fetchProducts(emit, sortKey: event.sortKey);
  }

  static const _sortLabelMap = {
    'newest': 'Mới nhất',
    'price_asc': 'Giá tăng dần',
    'price_desc': 'Giá giảm dần',
    'best_rated': 'Đánh giá cao',
  };

  Future<void> _onLoadMore(
      SearchLoadMore event, Emitter<SearchState> emit) async {
    if (!state.hasMore) return;

    _currentPage++;
    try {
      final response = await _productRepository.getProducts(
        search: state.query.isNotEmpty ? state.query : null,
        page: _currentPage,
        limit: 20,
        sort: state.sortKey,
        maxPrice: _maxPriceFromFilter(state.selectedFilter),
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
