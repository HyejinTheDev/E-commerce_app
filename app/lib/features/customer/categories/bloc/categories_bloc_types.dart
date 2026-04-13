import 'package:equatable/equatable.dart';
import '../../../category/domain/entities/category.dart';

enum CategoriesStatus { initial, loading, loaded, error }

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();
  @override
  List<Object?> get props => [];
}

class CategoriesLoaded extends CategoriesEvent {
  const CategoriesLoaded();
}

class CategoriesState extends Equatable {
  final CategoriesStatus status;
  final List<Category> categories;

  const CategoriesState({
    this.status = CategoriesStatus.initial,
    this.categories = const [],
  });

  CategoriesState copyWith({
    CategoriesStatus? status,
    List<Category>? categories,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [status, categories];
}
