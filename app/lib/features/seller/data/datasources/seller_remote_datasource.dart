import '../../../../core/network/dio_client.dart';

class SellerRemoteDataSource {
  final DioClient _client;

  SellerRemoteDataSource(this._client);

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _client.dio.get('/seller/dashboard');
    return response.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getProducts() async {
    final response = await _client.dio.get('/seller/products');
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> data) async {
    final response = await _client.dio.post('/seller/products', data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateProduct(String id, Map<String, dynamic> data) async {
    final response = await _client.dio.patch('/seller/products/$id', data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteProduct(String id) async {
    await _client.dio.delete('/seller/products/$id');
  }

  Future<List<dynamic>> getOrders() async {
    final response = await _client.dio.get('/seller/orders');
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> updateOrderStatus(String id, String status) async {
    final response = await _client.dio.patch('/seller/orders/$id/status', data: {'status': status});
    return response.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getCategories() async {
    final response = await _client.dio.get('/categories');
    return response.data as List<dynamic>;
  }
}
