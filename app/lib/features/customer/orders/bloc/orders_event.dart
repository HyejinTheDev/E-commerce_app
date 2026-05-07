import 'package:equatable/equatable.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();
  @override
  List<Object?> get props => [];
}

class OrdersLoaded extends OrdersEvent {
  const OrdersLoaded();
}

/// Pull-to-refresh — silently reloads without full loading spinner
class OrdersRefreshed extends OrdersEvent {
  const OrdersRefreshed();
}

class OrdersTabChanged extends OrdersEvent {
  final int tab;
  const OrdersTabChanged(this.tab);
  @override
  List<Object?> get props => [tab];
}
