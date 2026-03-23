import 'package:equatable/equatable.dart';
import '../../../../core/models/cart_item.dart';

/// Cart States
class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.total);
  double get tax => subtotal * 0.05;
  double get shipping => subtotal > 100 ? 0 : 12.00;
  double get total => subtotal + tax + shipping;
  bool get isEmpty => items.isEmpty;

  String get formattedSubtotal => '\$${subtotal.toStringAsFixed(2)}';
  String get formattedTax => '\$${tax.toStringAsFixed(2)}';
  String get formattedShipping => shipping == 0 ? 'Free' : '\$${shipping.toStringAsFixed(2)}';
  String get formattedTotal => '\$${total.toStringAsFixed(2)}';

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
