import '../entities/category.dart';

/// Abstract Category Repository — Domain Layer
abstract class CategoryRepository {
  Future<List<Category>> getCategories();
}
