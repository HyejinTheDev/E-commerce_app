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

  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.results = const [],
    this.filters = const [],
    this.selectedFilter = 0,
    this.totalResults = 0,
    this.hasMore = true,
  });

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<Product>? results,
    List<String>? filters,
    int? selectedFilter,
    int? totalResults,
    bool? hasMore,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      filters: filters ?? this.filters,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      totalResults: totalResults ?? this.totalResults,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props =>
      [status, query, results, filters, selectedFilter, totalResults, hasMore];
}
