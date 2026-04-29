import 'package:equatable/equatable.dart';
import '../../../../core/models/cart_item.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../voucher/domain/entities/voucher.dart';

/// Cart States
class CartState extends Equatable {
  final List<CartItem> items;
  final Voucher? appliedVoucher;
  final bool voucherLoading;
  final String? voucherError;

  const CartState({
    this.items = const [],
    this.appliedVoucher,
    this.voucherLoading = false,
    this.voucherError,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.total);
  double get tax => subtotal * 0.05;
  double get shipping => subtotal > 100 ? 0 : 12.00;

  /// Số tiền giảm giá từ voucher
  double get discount =>
      appliedVoucher != null ? appliedVoucher!.calculateDiscount(subtotal) : 0;

  double get total => subtotal - discount + tax + shipping;
  bool get isEmpty => items.isEmpty;

  String get formattedSubtotal => CurrencyFormatter.formatVnd(subtotal);
  String get formattedTax => CurrencyFormatter.formatVnd(tax);
  String get formattedShipping =>
      shipping == 0 ? 'Miễn phí' : CurrencyFormatter.formatVnd(shipping);
  String get formattedDiscount =>
      discount > 0 ? '-${CurrencyFormatter.formatVnd(discount)}' : '';
  String get formattedTotal => CurrencyFormatter.formatVnd(total);

  CartState copyWith({
    List<CartItem>? items,
    Voucher? appliedVoucher,
    bool? voucherLoading,
    String? voucherError,
    bool clearVoucher = false,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedVoucher:
          clearVoucher ? null : (appliedVoucher ?? this.appliedVoucher),
      voucherLoading: voucherLoading ?? this.voucherLoading,
      voucherError: voucherError,
    );
  }

  @override
  List<Object?> get props =>
      [items, appliedVoucher, voucherLoading, voucherError];
}
