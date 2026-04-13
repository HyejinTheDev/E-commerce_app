import '../../domain/entities/order.dart';

/// OrderModel — data layer JSON deserialization
class OrderModel {
  static Order fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.tryParse(json['createdAt'] as String? ?? '');
    final dateStr = createdAt != null
        ? '${_monthName(createdAt.month)} ${createdAt.day}, ${createdAt.year}'
        : 'Unknown';

    final items = json['items'] as List<dynamic>? ?? [];
    final status = OrderStatus.fromString(json['status'] as String? ?? '');

    String? deliveryEstimate;
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
}
