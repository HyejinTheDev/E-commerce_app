import 'package:equatable/equatable.dart';

/// Category model
class Category extends Equatable {
  final String id;
  final String name;
  final String iconName;
  final int productCount;
  final String? image;
  final String? slug;

  const Category({
    required this.id,
    required this.name,
    this.iconName = 'checkroom',
    this.productCount = 0,
    this.image,
    this.slug,
  });

  /// Parse from backend API JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    // Map category name to icon name
    final name = json['name'] as String;
    final iconMap = {
      'Clothing': 'checkroom',
      'Shoes': 'sports_gymnastics',
      'Bags': 'shopping_bag',
      'Accessories': 'watch',
      'Home & Living': 'home',
      'Beauty': 'face',
      'Electronics': 'devices',
      'Sports': 'fitness_center',
    };

    return Category(
      id: json['id'] as String,
      name: name,
      iconName: iconMap[name] ?? 'category',
      productCount: json['_count']?['products'] as int? ??
          (json['products'] as List?)?.length ??
          0,
      image: json['image'] as String?,
      slug: json['slug'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name];
}
