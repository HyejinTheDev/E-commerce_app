import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cart_item.dart';

/// Cart state
class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get tax => subtotal * 0.05;
  double get shipping => subtotal > 100 ? 0 : 12.00;
  double get total => subtotal + tax + shipping;

  String get formattedSubtotal => '\$${subtotal.toStringAsFixed(2)}';
  String get formattedTax => '\$${tax.toStringAsFixed(2)}';
  String get formattedShipping => shipping == 0 ? 'Free' : '\$${shipping.toStringAsFixed(2)}';
  String get formattedTotal => '\$${total.toStringAsFixed(2)}';

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}

/// Global CartCubit — manages the shopping cart
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addItem(CartItem item) {
    final existing = state.items.indexWhere((e) => e.productId == item.productId);
    if (existing >= 0) {
      final updated = List<CartItem>.from(state.items);
      updated[existing] = updated[existing].copyWith(
        quantity: updated[existing].quantity + 1,
      );
      emit(state.copyWith(items: updated));
    } else {
      emit(state.copyWith(items: [...state.items, item]));
    }
  }

  void removeItem(String productId) {
    final updated = state.items.where((e) => e.productId != productId).toList();
    emit(state.copyWith(items: updated));
  }

  void increment(String productId) {
    final updated = state.items.map((item) {
      if (item.productId == productId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updated));
  }

  void decrement(String productId) {
    final updated = state.items.map((item) {
      if (item.productId == productId && item.quantity > 1) {
        return item.copyWith(quantity: item.quantity - 1);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updated));
  }

  void clear() {
    emit(const CartState());
  }
}
