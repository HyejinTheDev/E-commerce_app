import '../../domain/entities/product.dart';

/// Data model with JSON serialization — extends domain entity concept
class ProductModel {
  /// Parse from backend API JSON (Prisma Product with shop & category includes)
  static Product fromJson(Map<String, dynamic> json) {
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
}
