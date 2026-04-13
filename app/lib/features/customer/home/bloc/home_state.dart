import 'package:equatable/equatable.dart';
import '../../../product/domain/entities/product.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Product> featuredProducts;
  final List<String> categories;
  final int selectedCategory;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.featuredProducts = const [],
    this.categories = const [],
    this.selectedCategory = 0,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Product>? featuredProducts,
    List<String>? categories,
    int? selectedCategory,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, featuredProducts, categories, selectedCategory, errorMessage];
}
