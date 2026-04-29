import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/cart_item.dart';
import '../../../voucher/domain/usecases/validate_voucher_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

/// CartBloc — manages shopping cart + voucher with Event-driven state
class CartBloc extends Bloc<CartEvent, CartState> {
  final ValidateVoucherUseCase? _validateVoucher;

  CartBloc({ValidateVoucherUseCase? validateVoucher})
      : _validateVoucher = validateVoucher,
        super(const CartState()) {
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartItemIncremented>(_onItemIncremented);
    on<CartItemDecremented>(_onItemDecremented);
    on<CartCleared>(_onCleared);
    on<VoucherApplied>(_onVoucherApplied);
    on<VoucherRemoved>(_onVoucherRemoved);
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

  // ─── Voucher handlers ───

  Future<void> _onVoucherApplied(
      VoucherApplied event, Emitter<CartState> emit) async {
    if (_validateVoucher == null) return;

    emit(state.copyWith(voucherLoading: true, voucherError: null));

    try {
      final voucher = await _validateVoucher.call(event.code);

      // Check minimum order
      if (state.subtotal < voucher.minOrder) {
        emit(state.copyWith(
          voucherLoading: false,
          voucherError:
              'Đơn hàng tối thiểu \$${voucher.minOrder.toStringAsFixed(0)} để dùng mã này',
        ));
        return;
      }

      emit(state.copyWith(
        appliedVoucher: voucher,
        voucherLoading: false,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        voucherLoading: false,
        voucherError: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  void _onVoucherRemoved(VoucherRemoved event, Emitter<CartState> emit) {
    emit(state.copyWith(clearVoucher: true, voucherError: null));
  }
}
