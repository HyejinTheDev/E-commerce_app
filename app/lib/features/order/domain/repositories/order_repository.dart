import '../entities/order.dart';

/// Abstract Order Repository — Domain Layer
abstract class OrderRepository {
  Future<List<Order>> getMyOrders();
  Future<Order> createOrder({
    required String addressId,
    required List<Map<String, dynamic>> items,
    String? paymentMethod,
    String? note,
  });
  Future<Order> trackOrder(String orderId);
}
