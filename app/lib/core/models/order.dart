import 'package:equatable/equatable.dart';

/// Order status enum matching backend Prisma enum
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipping,
  delivered,
  cancelled,
  returned;

  /// Parse from backend string (e.g. "PENDING" → OrderStatus.pending)
  static OrderStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return OrderStatus.pending;
      case 'CONFIRMED':
        return OrderStatus.confirmed;
      case 'PROCESSING':
        return OrderStatus.processing;
      case 'SHIPPING':
        return OrderStatus.shipping;
      case 'DELIVERED':
        return OrderStatus.delivered;
      case 'CANCELLED':
        return OrderStatus.cancelled;
      case 'RETURNED':
        return OrderStatus.returned;
      default:
        return OrderStatus.pending;
    }
  }
}

/// Order model
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

  /// Parse from backend API JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    // Parse createdAt to readable date
    final createdAt = DateTime.tryParse(json['createdAt'] as String? ?? '');
    final dateStr = createdAt != null
        ? '${_monthName(createdAt.month)} ${createdAt.day}, ${createdAt.year}'
        : 'Unknown';

    final items = json['items'] as List<dynamic>? ?? [];

    // Generate delivery estimate based on status
    String? deliveryEstimate;
    final status = OrderStatus.fromString(json['status'] as String? ?? '');
    if (status == OrderStatus.shipping) {
      deliveryEstimate = 'Arriving soon';
    } else if (status == OrderStatus.processing) {
      deliveryEstimate = 'Preparing your order';
    }

    return Order(
      id: json['id'] as String,
      date: dateStr,
      status: status,
      totalAmount: double.tryParse(json['totalAmount'].toString()) ?? 0,
      itemCount: items.length,
      deliveryEstimate: deliveryEstimate,
    );
  }

  static String _monthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  String get formattedTotal => '\$${totalAmount.toStringAsFixed(2)}';

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipping:
        return 'In Transit';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
    }
  }

  @override
  List<Object?> get props => [id, status];
}
