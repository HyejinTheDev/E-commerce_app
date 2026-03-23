import 'package:equatable/equatable.dart';

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

  String get formattedTotal => '\$${totalAmount.toStringAsFixed(2)}';

  String get statusLabel {
    switch (status) {
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.inTransit:
        return 'In Transit';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  List<Object?> get props => [id, status];
}

enum OrderStatus { processing, inTransit, delivered, cancelled }
