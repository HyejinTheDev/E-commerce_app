import 'package:equatable/equatable.dart';

/// Category model
class Category extends Equatable {
  final String id;
  final String name;
  final String iconName;
  final int productCount;

  const Category({
    required this.id,
    required this.name,
    this.iconName = 'checkroom',
    this.productCount = 0,
  });

  @override
  List<Object?> get props => [id, name];
}
