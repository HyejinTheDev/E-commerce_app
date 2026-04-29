import 'package:equatable/equatable.dart';
import '../../../../core/utils/currency_formatter.dart';

/// Order status enum matching backend Prisma enum
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipping,
  delivered,
  cancelled,
  returned;

  static OrderStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING': return OrderStatus.pending;
      case 'CONFIRMED': return OrderStatus.confirmed;
      case 'PROCESSING': return OrderStatus.processing;
      case 'SHIPPING': return OrderStatus.shipping;
      case 'DELIVERED': return OrderStatus.delivered;
      case 'CANCELLED': return OrderStatus.cancelled;
      case 'RETURNED': return OrderStatus.returned;
      default: return OrderStatus.pending;
    }
  }
}

/// Pure Order entity — Domain Layer
class Order extends Equatable {
  final String id;
  final String date;
  final OrderStatus status;
  final double totalAmount;
  final int itemCount;
  final String? deliveryEstimate;

  const Order({
    required this.id,
    required this.date,
    required this.status,
    required this.totalAmount,
    this.itemCount = 0,
    this.deliveryEstimate,
  });

  String get formattedTotal => CurrencyFormatter.formatVnd(totalAmount);

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending: return 'Chờ xác nhận';
      case OrderStatus.confirmed: return 'Đã xác nhận';
      case OrderStatus.processing: return 'Đang xử lý';
      case OrderStatus.shipping: return 'Đang giao';
      case OrderStatus.delivered: return 'Đã giao';
      case OrderStatus.cancelled: return 'Đã huỷ';
      case OrderStatus.returned: return 'Đã trả';
    }
  }

  @override
  List<Object?> get props => [id, status];
}
