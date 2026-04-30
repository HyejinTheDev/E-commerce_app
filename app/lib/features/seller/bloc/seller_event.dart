import 'package:equatable/equatable.dart';

abstract class SellerEvent extends Equatable {
  const SellerEvent();
  @override
  List<Object?> get props => [];
}

class SellerDashboardLoaded extends SellerEvent {
  const SellerDashboardLoaded();
}

class SellerProductsLoaded extends SellerEvent {
  const SellerProductsLoaded();
}

class SellerProductDeleted extends SellerEvent {
  final String productId;
  const SellerProductDeleted(this.productId);
  @override
  List<Object?> get props => [productId];
}

class SellerOrdersLoaded extends SellerEvent {
  const SellerOrdersLoaded();
}

class SellerOrderStatusUpdated extends SellerEvent {
  final String orderId;
  final String status;
  const SellerOrderStatusUpdated(this.orderId, this.status);
  @override
  List<Object?> get props => [orderId, status];
}
