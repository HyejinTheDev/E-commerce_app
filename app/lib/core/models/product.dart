import 'package:equatable/equatable.dart';

/// Shared product model used across the app
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
  final List<int> colors; // hex color values
  final double rating;
  final int reviewCount;
  final String category;

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
  });

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String? get formattedOriginalPrice =>
      originalPrice != null ? '\$${originalPrice!.toStringAsFixed(2)}' : null;

  @override
  List<Object?> get props => [id, name, brand, price];
}
