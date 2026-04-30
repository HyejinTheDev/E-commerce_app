import '../../../../core/network/dio_client.dart';

/// Remote data source for product API calls
class ProductRemoteDataSource {
  final DioClient _client;

  ProductRemoteDataSource(this._client);

  Future<Map<String, dynamic>> getProducts({
    String? search,
    String? categoryId,
    int page = 1,
    int limit = 20,
    String? sort,
    double? maxPrice,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (categoryId != null) queryParams['categoryId'] = categoryId;
    if (sort != null && sort.isNotEmpty) queryParams['sort'] = sort;
    if (maxPrice != null) queryParams['maxPrice'] = maxPrice;

    final response = await _client.dio.get(
      '/products',
      queryParameters: queryParams,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getProductById(String id) async {
    final response = await _client.dio.get('/products/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<void> addReview(String productId, int rating, String? comment) async {
    await _client.dio.post(
      '/products/$productId/reviews',
      data: {
        'rating': rating,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      },
    );
  }
}
