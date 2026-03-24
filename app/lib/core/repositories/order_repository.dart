import '../models/order.dart';
import '../network/dio_client.dart';

/// Repository for order-related API calls
class OrderRepository {
  final DioClient _client;

  OrderRepository(this._client);

  /// Fetch current user's orders
  /// GET /orders (requires auth)
  Future<List<Order>> getMyOrders() async {
    final response = await _client.dio.get('/orders');
    final data = response.data as List<dynamic>;
    return data
        .map((json) => Order.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Create a new order
  /// POST /orders (requires auth)
  Future<Order> createOrder({
    required String addressId,
    required List<Map<String, dynamic>> items,
    String? paymentMethod,
    String? note,
  }) async {
    final response = await _client.dio.post('/orders', data: {
      'addressId': addressId,
      'items': items,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (note != null) 'note': note,
    });
    return Order.fromJson(response.data as Map<String, dynamic>);
  }

  /// Track a specific order
  /// GET /orders/:id/track
  Future<Order> trackOrder(String orderId) async {
    final response = await _client.dio.get('/orders/$orderId/track');
    return Order.fromJson(response.data as Map<String, dynamic>);
  }
}
