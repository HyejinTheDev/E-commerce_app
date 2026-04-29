import '../../domain/entities/product.dart';
import '../../domain/entities/review.dart';

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
      badge = 'Giảm $discount%';
    }

    // Extract reviews info
    final reviewsJson = json['reviews'] as List<dynamic>? ?? [];
    final avgRating = reviewsJson.isNotEmpty
        ? reviewsJson.fold<double>(0, (sum, r) => sum + (r['rating'] as int)) /
            reviewsJson.length
        : 0.0;
        
    final parsedReviews = reviewsJson.map((r) {
      final user = r['user'] as Map<String, dynamic>?;
      return Review(
        id: r['id'] as String,
        userName: user?['name'] as String? ?? 'Khách',
        userAvatar: user?['avatar'] as String?,
        rating: r['rating'] as int,
        comment: r['comment'] as String?,
        createdAt: DateTime.tryParse(r['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
    }).toList();

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
      reviewCount: reviewsJson.length,
      category: json['category']?['name'] as String? ?? '',
      images: imagesList,
      stock: json['stock'] as int? ?? 0,
      reviews: parsedReviews,
    );
  }
}
