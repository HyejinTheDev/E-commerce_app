import 'package:equatable/equatable.dart';

/// Cart item model
class CartItem extends Equatable {
  final String productId;
  final String name;
  final String brand;
  final double price;
  final String imageUrl;
  final int quantity;
  final String? selectedSize;
  final int? selectedColor;

  const CartItem({
    required this.productId,
    required this.name,
    required this.brand,
    required this.price,
    this.imageUrl = '',
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });

  double get total => price * quantity;
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get formattedTotal => '\$${total.toStringAsFixed(2)}';

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      name: name,
      brand: brand,
      price: price,
      imageUrl: imageUrl,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize,
      selectedColor: selectedColor,
    );
  }

  @override
  List<Object?> get props => [productId, name, quantity, selectedSize, selectedColor];
}
