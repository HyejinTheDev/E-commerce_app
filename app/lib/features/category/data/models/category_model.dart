import '../../domain/entities/category.dart';

/// CategoryModel — data layer JSON deserialization
class CategoryModel {
  static Category fromJson(Map<String, dynamic> json) {
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
}
