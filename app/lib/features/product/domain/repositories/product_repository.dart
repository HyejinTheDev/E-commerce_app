import '../entities/product.dart';

/// Abstract Product Repository — Domain Layer
abstract class ProductRepository {
  Future<ProductListResponse> getProducts({
    String? search,
    String? categoryId,
    int page = 1,
    int limit = 20,
  });

  Future<Product> getProductById(String id);
}
