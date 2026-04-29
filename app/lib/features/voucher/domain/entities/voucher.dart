import 'package:equatable/equatable.dart';

/// Voucher entity — Domain Layer
class Voucher extends Equatable {
  final String id;
  final String code;
  final double discount; // percentage (e.g. 10 = 10%)
  final double minOrder;
  final DateTime expiresAt;

  const Voucher({
    required this.id,
    required this.code,
    required this.discount,
    this.minOrder = 0,
    required this.expiresAt,
  });

  /// Tính số tiền giảm từ subtotal (USD)
  double calculateDiscount(double subtotal) {
    return subtotal * discount / 100;
  }

  @override
  List<Object?> get props => [id, code, discount];
}
