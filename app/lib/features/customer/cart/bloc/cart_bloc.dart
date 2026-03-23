import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

/// CartBloc — manages shopping cart with Event-driven state
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartItemIncremented>(_onItemIncremented);
    on<CartItemDecremented>(_onItemDecremented);
    on<CartCleared>(_onCleared);
  }

  void _onItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    final existingIndex =
        state.items.indexWhere((e) => e.productId == event.productId);

    if (existingIndex >= 0) {
      final updated = List<CartItem>.from(state.items);
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + 1,
      );
      emit(state.copyWith(items: updated));
    } else {
      final newItem = CartItem(
        productId: event.productId,
        name: event.name,
        brand: event.brand,
        price: event.price,
        imageUrl: event.imageUrl,
        selectedSize: event.selectedSize,
        selectedColor: event.selectedColor,
      );
      emit(state.copyWith(items: [...state.items, newItem]));
    }
  }

  void _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final updated =
        state.items.where((e) => e.productId != event.productId).toList();
    emit(state.copyWith(items: updated));
  }

  void _onItemIncremented(CartItemIncremented event, Emitter<CartState> emit) {
    final updated = state.items.map((item) {
      if (item.productId == event.productId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updated));
  }

  void _onItemDecremented(CartItemDecremented event, Emitter<CartState> emit) {
    final updated = state.items.map((item) {
      if (item.productId == event.productId && item.quantity > 1) {
        return item.copyWith(quantity: item.quantity - 1);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updated));
  }

  void _onCleared(CartCleared event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}
