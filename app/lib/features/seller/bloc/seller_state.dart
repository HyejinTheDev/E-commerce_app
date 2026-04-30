import 'package:equatable/equatable.dart';

enum SellerStatus { initial, loading, loaded, error }

class SellerState extends Equatable {
  final SellerStatus status;
  final String? shopName;
  final String? shopStatus;
  final int totalProducts;
  final int totalOrders;
  final int pendingOrders;
  final double totalRevenue;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> orders;
  final String? errorMessage;

  const SellerState({
    this.status = SellerStatus.initial,
    this.shopName,
    this.shopStatus,
    this.totalProducts = 0,
    this.totalOrders = 0,
    this.pendingOrders = 0,
    this.totalRevenue = 0,
    this.products = const [],
    this.orders = const [],
    this.errorMessage,
  });

  SellerState copyWith({
    SellerStatus? status,
    String? shopName,
    String? shopStatus,
    int? totalProducts,
    int? totalOrders,
    int? pendingOrders,
    double? totalRevenue,
    List<Map<String, dynamic>>? products,
    List<Map<String, dynamic>>? orders,
    String? errorMessage,
  }) {
    return SellerState(
      status: status ?? this.status,
      shopName: shopName ?? this.shopName,
      shopStatus: shopStatus ?? this.shopStatus,
      totalProducts: totalProducts ?? this.totalProducts,
      totalOrders: totalOrders ?? this.totalOrders,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      products: products ?? this.products,
      orders: orders ?? this.orders,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, shopName, totalProducts, totalOrders, pendingOrders, totalRevenue, products, orders, errorMessage];
}
