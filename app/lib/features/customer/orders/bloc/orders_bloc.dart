import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../order/domain/entities/order.dart';
import '../../../order/domain/repositories/order_repository.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository _orderRepository;

  OrdersBloc(this._orderRepository) : super(const OrdersState()) {
    on<OrdersLoaded>(_onLoaded);
    on<OrdersRefreshed>(_onRefreshed);
    on<OrdersTabChanged>(_onTabChanged);
  }

  Future<void> _onLoaded(OrdersLoaded event, Emitter<OrdersState> emit) async {
    emit(state.copyWith(status: OrdersStatus.loading));

    try {
      final orders = await _orderRepository.getMyOrders();
      emit(state.copyWith(
        status: OrdersStatus.loaded,
        allOrders: orders,
        filteredOrders: orders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrdersStatus.error,
      ));
    }
  }

  /// Pull-to-refresh — reload orders then re-apply current tab filter
  Future<void> _onRefreshed(
      OrdersRefreshed event, Emitter<OrdersState> emit) async {
    try {
      final orders = await _orderRepository.getMyOrders();
      emit(state.copyWith(
        status: OrdersStatus.loaded,
        allOrders: orders,
      ));
      // Re-apply current tab filter
      add(OrdersTabChanged(state.selectedTab));
    } catch (_) {
      // Keep current data on refresh error
    }
  }

  void _onTabChanged(OrdersTabChanged event, Emitter<OrdersState> emit) {
    emit(state.copyWith(selectedTab: event.tab));

    List<Order> filtered;
    switch (event.tab) {
      case 1: // Active
        filtered = state.allOrders
            .where((o) =>
                o.status == OrderStatus.pending ||
                o.status == OrderStatus.confirmed ||
                o.status == OrderStatus.processing ||
                o.status == OrderStatus.shipping)
            .toList();
        break;
      case 2: // Completed
        filtered = state.allOrders
            .where((o) => o.status == OrderStatus.delivered)
            .toList();
        break;
      case 3: // Cancelled
        filtered = state.allOrders
            .where((o) =>
                o.status == OrderStatus.cancelled ||
                o.status == OrderStatus.returned)
            .toList();
        break;
      default: // All
        filtered = state.allOrders;
    }
    emit(state.copyWith(filteredOrders: filtered));
  }
}
