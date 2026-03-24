import '../models/product.dart';
import '../network/dio_client.dart';

/// Repository for product-related API calls
class ProductRepository {
  final DioClient _client;

  ProductRepository(this._client);

  /// Fetch paginated product list with optional search & category filter
  /// GET /products?search=&categoryId=&page=&limit=
  Future<ProductListResponse> getProducts({
    String? search,
    String? categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (categoryId != null) queryParams['categoryId'] = categoryId;

    final response = await _client.dio.get(
      '/products',
      queryParameters: queryParams,
    );

    final data = response.data;
    final products = (data['data'] as List<dynamic>)
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();

    return ProductListResponse(
      products: products,
      total: data['total'] as int,
      page: data['page'] as int,
      pages: data['pages'] as int,
    );
  }

  /// Fetch single product by ID
  /// GET /products/:id
  Future<Product> getProductById(String id) async {
    final response = await _client.dio.get('/products/$id');
    return Product.fromJson(response.data as Map<String, dynamic>);
  }
}

/// Response wrapper for paginated product list
class ProductListResponse {
  final List<Product> products;
  final int total;
  final int page;
  final int pages;

  const ProductListResponse({
    required this.products,
    required this.total,
    required this.page,
    required this.pages,
  });

  bool get hasMore => page < pages;
}
