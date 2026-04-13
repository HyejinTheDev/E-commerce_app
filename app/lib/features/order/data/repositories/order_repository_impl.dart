import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remoteDataSource;
  OrderRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Order>> getMyOrders() async {
    final data = await _remoteDataSource.getMyOrders();
    return data
        .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Order> createOrder({
    required String addressId,
    required List<Map<String, dynamic>> items,
    String? paymentMethod,
    String? note,
  }) async {
    final data = await _remoteDataSource.createOrder({
      'addressId': addressId,
      'items': items,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (note != null) 'note': note,
    });
    return OrderModel.fromJson(data);
  }

  @override
  Future<Order> trackOrder(String orderId) async {
    final data = await _remoteDataSource.trackOrder(orderId);
    return OrderModel.fromJson(data);
  }
}
