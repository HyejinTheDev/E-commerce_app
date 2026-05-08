import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';
import 'package:injectable/injectable.dart';

/// Concrete implementation of [ProductRepository]
@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  static const String _boxName = 'productCacheBox';

  ProductRepositoryImpl(this._remoteDataSource);

  Future<Box> _getBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return await Hive.openBox(_boxName);
  }

  @override
  Future<ProductListResponse> getProducts({
    String? search,
    String? categoryId,
    int page = 1,
    int limit = 20,
    String? sort,
    double? maxPrice,
  }) async {
    final box = await _getBox();
    final cacheKey = 'cached_products_${categoryId ?? "all"}_${page}';

    Map<String, dynamic> data;
    try {
      data = await _remoteDataSource.getProducts(
        search: search,
        categoryId: categoryId,
        page: page,
        limit: limit,
        sort: sort,
        maxPrice: maxPrice,
      );
      // Save to Hive cache
      await box.put(cacheKey, jsonEncode(data));
    } catch (e) {
      // Fallback to offline cache
      final cachedStr = box.get(cacheKey) as String?;
      if (cachedStr != null) {
        data = jsonDecode(cachedStr) as Map<String, dynamic>;
      } else {
        rethrow;
      }
    }

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
    final box = await _getBox();
    final cacheKey = 'cached_product_$id';

    try {
      final data = await _remoteDataSource.getProductById(id);
      await box.put(cacheKey, jsonEncode(data));
      return ProductModel.fromJson(data);
    } catch (e) {
      final cachedStr = box.get(cacheKey) as String?;
      if (cachedStr != null) {
        return ProductModel.fromJson(jsonDecode(cachedStr));
      }
      rethrow;
    }
  }

  @override
  Future<void> addReview(String productId, int rating, String? comment) async {
    await _remoteDataSource.addReview(productId, rating, comment);
  }
}
