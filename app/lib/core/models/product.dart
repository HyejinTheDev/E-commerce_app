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
  final List<String> images;
  final int stock;

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
  });

  /// Parse from backend API JSON (Prisma Product with shop & category includes)
  factory Product.fromJson(Map<String, dynamic> json) {
    final salePrice = json['salePrice'] != null
        ? double.tryParse(json['salePrice'].toString())
        : null;
    final basePrice = double.tryParse(json['price'].toString()) ?? 0;
    final imagesList = (json['images'] as List<dynamic>?)?.cast<String>() ?? [];

    // Calculate badge
    String? badge;
    if (salePrice != null && salePrice < basePrice) {
      final discount = ((basePrice - salePrice) / basePrice * 100).round();
      badge = '$discount% OFF';
    }

    // Extract reviews info
    final reviews = json['reviews'] as List<dynamic>? ?? [];
    final avgRating = reviews.isNotEmpty
        ? reviews.fold<double>(0, (sum, r) => sum + (r['rating'] as int)) /
            reviews.length
        : 0.0;

    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['shop']?['name'] as String? ?? 'Unknown',
      price: salePrice ?? basePrice,
      originalPrice: salePrice != null ? basePrice : null,
      badge: badge,
      imageUrl: imagesList.isNotEmpty ? imagesList.first : '',
      description: json['description'] as String? ?? '',
      rating: avgRating,
      reviewCount: reviews.length,
      category: json['category']?['name'] as String? ?? '',
      images: imagesList,
      stock: json['stock'] as int? ?? 0,
    );
  }

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String? get formattedOriginalPrice =>
      originalPrice != null ? '\$${originalPrice!.toStringAsFixed(2)}' : null;

  @override
  List<Object?> get props => [id, name, brand, price];
}
