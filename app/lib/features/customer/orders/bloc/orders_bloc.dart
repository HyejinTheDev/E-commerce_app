import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/mock_data.dart';
import '../../../../core/models/order.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(const OrdersState()) {
    on<OrdersLoaded>(_onLoaded);
    on<OrdersTabChanged>(_onTabChanged);
  }

  Future<void> _onLoaded(OrdersLoaded event, Emitter<OrdersState> emit) async {
    emit(state.copyWith(status: OrdersStatus.loading));

    await Future.delayed(const Duration(milliseconds: 400));

    emit(state.copyWith(
      status: OrdersStatus.loaded,
      allOrders: MockData.orders,
      filteredOrders: MockData.orders,
    ));
  }

  void _onTabChanged(OrdersTabChanged event, Emitter<OrdersState> emit) {
    emit(state.copyWith(selectedTab: event.tab));

    List<Order> filtered;
    switch (event.tab) {
      case 1: // Active
        filtered = state.allOrders
            .where((o) =>
                o.status == OrderStatus.processing ||
                o.status == OrderStatus.inTransit)
            .toList();
        break;
      case 2: // Completed
        filtered = state.allOrders
            .where((o) => o.status == OrderStatus.delivered)
            .toList();
        break;
      case 3: // Cancelled
        filtered = state.allOrders
            .where((o) => o.status == OrderStatus.cancelled)
            .toList();
        break;
      default: // All
        filtered = state.allOrders;
    }
    emit(state.copyWith(filteredOrders: filtered));
  }
}
