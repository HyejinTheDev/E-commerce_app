import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/datasources/seller_remote_datasource.dart';
import 'seller_event.dart';
import 'seller_state.dart';

class SellerBloc extends Bloc<SellerEvent, SellerState> {
  final SellerRemoteDataSource _dataSource;

  SellerBloc(this._dataSource) : super(const SellerState()) {
    on<SellerDashboardLoaded>(_onDashboardLoaded);
    on<SellerProductsLoaded>(_onProductsLoaded);
    on<SellerProductDeleted>(_onProductDeleted);
    on<SellerOrdersLoaded>(_onOrdersLoaded);
    on<SellerOrderStatusUpdated>(_onOrderStatusUpdated);
  }

  Future<void> _onDashboardLoaded(
      SellerDashboardLoaded event, Emitter<SellerState> emit) async {
    emit(state.copyWith(status: SellerStatus.loading));
    try {
      final data = await _dataSource.getDashboard();
      final shop = data['shop'] as Map<String, dynamic>?;
      final stats = data['stats'] as Map<String, dynamic>?;
      emit(state.copyWith(
        status: SellerStatus.loaded,
        shopName: shop?['name'] as String?,
        shopStatus: shop?['status'] as String?,
        totalProducts: stats?['totalProducts'] as int? ?? 0,
        totalOrders: stats?['totalOrders'] as int? ?? 0,
        pendingOrders: stats?['pendingOrders'] as int? ?? 0,
        totalRevenue: (stats?['totalRevenue'] as num?)?.toDouble() ?? 0,
      ));
    } catch (e) {
      emit(state.copyWith(status: SellerStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onProductsLoaded(
      SellerProductsLoaded event, Emitter<SellerState> emit) async {
    emit(state.copyWith(status: SellerStatus.loading));
    try {
      final data = await _dataSource.getProducts();
      final products = data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      emit(state.copyWith(status: SellerStatus.loaded, products: products));
    } catch (e) {
      emit(state.copyWith(status: SellerStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onProductDeleted(
      SellerProductDeleted event, Emitter<SellerState> emit) async {
    try {
      await _dataSource.deleteProduct(event.productId);
      final updatedProducts = state.products.where((p) => p['id'] != event.productId).toList();
      emit(state.copyWith(products: updatedProducts));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Xóa thất bại: $e'));
    }
  }

  Future<void> _onOrdersLoaded(
      SellerOrdersLoaded event, Emitter<SellerState> emit) async {
    emit(state.copyWith(status: SellerStatus.loading));
    try {
      final data = await _dataSource.getOrders();
      final orders = data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      emit(state.copyWith(status: SellerStatus.loaded, orders: orders));
    } catch (e) {
      emit(state.copyWith(status: SellerStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onOrderStatusUpdated(
      SellerOrderStatusUpdated event, Emitter<SellerState> emit) async {
    try {
      await _dataSource.updateOrderStatus(event.orderId, event.status);
      add(const SellerOrdersLoaded()); // Refresh
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Cập nhật thất bại: $e'));
    }
  }
}
