import 'package:equatable/equatable.dart';

/// Cart Events
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartItemAdded extends CartEvent {
  final String productId;
  final String name;
  final String brand;
  final double price;
  final String imageUrl;
  final String? selectedSize;
  final int? selectedColor;

  const CartItemAdded({
    required this.productId,
    required this.name,
    required this.brand,
    required this.price,
    this.imageUrl = '',
    this.selectedSize,
    this.selectedColor,
  });

  @override
  List<Object?> get props => [productId, name, price, selectedSize, selectedColor];
}

class CartItemRemoved extends CartEvent {
  final String productId;
  const CartItemRemoved(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CartItemIncremented extends CartEvent {
  final String productId;
  const CartItemIncremented(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CartItemDecremented extends CartEvent {
  final String productId;
  const CartItemDecremented(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CartCleared extends CartEvent {
  const CartCleared();
}

// ─── Voucher Events ───

class VoucherApplied extends CartEvent {
  final String code;
  const VoucherApplied(this.code);

  @override
  List<Object?> get props => [code];
}

class VoucherRemoved extends CartEvent {
  const VoucherRemoved();
}
