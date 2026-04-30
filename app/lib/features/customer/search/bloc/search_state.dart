import 'package:equatable/equatable.dart';
import '../../../product/domain/entities/product.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchState extends Equatable {
  final SearchStatus status;
  final String query;
  final List<Product> results;
  final List<String> filters;
  final int selectedFilter;
  final int totalResults;
  final bool hasMore;
  final String sortKey;       // newest, price_asc, price_desc, best_rated
  final String sortLabel;     // display name

  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.results = const [],
    this.filters = const [],
    this.selectedFilter = 0,
    this.totalResults = 0,
    this.hasMore = true,
    this.sortKey = 'newest',
    this.sortLabel = 'Mới nhất',
  });

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<Product>? results,
    List<String>? filters,
    int? selectedFilter,
    int? totalResults,
    bool? hasMore,
    String? sortKey,
    String? sortLabel,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      filters: filters ?? this.filters,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      totalResults: totalResults ?? this.totalResults,
      hasMore: hasMore ?? this.hasMore,
      sortKey: sortKey ?? this.sortKey,
      sortLabel: sortLabel ?? this.sortLabel,
    );
  }

  @override
  List<Object?> get props =>
      [status, query, results, filters, selectedFilter, totalResults, hasMore, sortKey, sortLabel];
}
