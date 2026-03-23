import 'package:equatable/equatable.dart';
import '../../../../core/models/order.dart';

enum OrdersStatus { initial, loading, loaded, error }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<Order> allOrders;
  final List<Order> filteredOrders;
  final int selectedTab;
  final List<String> tabs;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.allOrders = const [],
    this.filteredOrders = const [],
    this.selectedTab = 0,
    this.tabs = const ['All', 'Active', 'Completed', 'Cancelled'],
  });

  OrdersState copyWith({
    OrdersStatus? status,
    List<Order>? allOrders,
    List<Order>? filteredOrders,
    int? selectedTab,
  }) {
    return OrdersState(
      status: status ?? this.status,
      allOrders: allOrders ?? this.allOrders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      selectedTab: selectedTab ?? this.selectedTab,
      tabs: tabs,
    );
  }

  @override
  List<Object?> get props =>
      [status, allOrders, filteredOrders, selectedTab];
}
