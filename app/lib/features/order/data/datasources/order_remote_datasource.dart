import '../../../../core/network/dio_client.dart';

class OrderRemoteDataSource {
  final DioClient _client;
  OrderRemoteDataSource(this._client);

  Future<List<dynamic>> getMyOrders() async {
    final response = await _client.dio.get('/orders');
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> data) async {
    final response = await _client.dio.post('/orders', data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> trackOrder(String orderId) async {
    final response = await _client.dio.get('/orders/$orderId/track');
    return response.data as Map<String, dynamic>;
  }
}
