import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class SearchFilterSelected extends SearchEvent {
  final int index;
  const SearchFilterSelected(this.index);
  @override
  List<Object?> get props => [index];
}

class SearchSortChanged extends SearchEvent {
  final String sortKey;
  const SearchSortChanged(this.sortKey);
  @override
  List<Object?> get props => [sortKey];
}

class SearchLoadMore extends SearchEvent {
  const SearchLoadMore();
}
