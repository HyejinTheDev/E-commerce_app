import 'package:equatable/equatable.dart';
import '../../../../core/utils/currency_formatter.dart';
import 'review.dart';

/// Pure domain entity — no fromJson, no framework dependencies
class Product extends Equatable {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double? originalPrice;
  final String? badge;
  final String imageUrl;
  final String description;
  final List<String> sizes;
  final List<int> colors;
  final double rating;
  final int reviewCount;
  final String category;
  final List<String> images;
  final int stock;
  final List<Review> reviews;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.originalPrice,
    this.badge,
    this.imageUrl = '',
    this.description = '',
    this.sizes = const ['XS', 'S', 'M', 'L', 'XL'],
    this.colors = const [0xFFE8E2D8, 0xFF1A1A1A, 0xFFC5B9A8, 0xFF7D9B76],
    this.rating = 0,
    this.reviewCount = 0,
    this.category = '',
    this.images = const [],
    this.stock = 0,
    this.reviews = const [],
  });

  String get formattedPrice => CurrencyFormatter.formatVnd(price);
  String? get formattedOriginalPrice =>
      originalPrice != null ? CurrencyFormatter.formatVnd(originalPrice!) : null;

  @override
  List<Object?> get props => [id, name, brand, price];
}

/// Response wrapper for paginated product list
class ProductListResponse {
  final List<Product> products;
  final int total;
  final int page;
  final int pages;

  const ProductListResponse({
    required this.products,
    required this.total,
    required this.page,
    required this.pages,
  });

  bool get hasMore => page < pages;
}
