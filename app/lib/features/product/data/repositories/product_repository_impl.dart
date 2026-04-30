import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

/// Concrete implementation of [ProductRepository]
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<ProductListResponse> getProducts({
    String? search,
    String? categoryId,
    int page = 1,
    int limit = 20,
    String? sort,
    double? maxPrice,
  }) async {
    final data = await _remoteDataSource.getProducts(
      search: search,
      categoryId: categoryId,
      page: page,
      limit: limit,
      sort: sort,
      maxPrice: maxPrice,
    );

    final products = (data['data'] as List<dynamic>)
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return ProductListResponse(
      products: products,
      total: data['total'] as int,
      page: data['page'] as int,
      pages: data['pages'] as int,
    );
  }

  @override
  Future<Product> getProductById(String id) async {
    final data = await _remoteDataSource.getProductById(id);
    return ProductModel.fromJson(data);
  }

  @override
  Future<void> addReview(String productId, int rating, String? comment) async {
    await _remoteDataSource.addReview(productId, rating, comment);
  }
}
