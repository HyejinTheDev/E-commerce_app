import 'package:equatable/equatable.dart';

/// Pure Category entity — Domain Layer
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

  @override
  List<Object?> get props => [id, name];
}
