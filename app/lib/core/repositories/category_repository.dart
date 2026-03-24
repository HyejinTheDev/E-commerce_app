import '../models/category.dart';
import '../network/dio_client.dart';

/// Repository for category-related API calls
class CategoryRepository {
  final DioClient _client;

  CategoryRepository(this._client);

  /// Fetch all categories
  /// GET /categories
  Future<List<Category>> getCategories() async {
    final response = await _client.dio.get('/categories');
    final data = response.data as List<dynamic>;
    return data
        .map((json) => Category.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
