import 'package:equatable/equatable.dart';
import '../../../../core/utils/currency_formatter.dart';

enum CheckoutStatus { initial, loading, placing, success, error }

class CheckoutState extends Equatable {
  final CheckoutStatus status;
  final int deliveryOption;
  final String shippingName;
  final String shippingAddress;
  final String paymentLast4;
  final String paymentBrand;
  final String? errorMessage;
  final String? orderId;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.deliveryOption = 0,
    this.shippingName = 'Nguyễn Thị Mai',
    this.shippingAddress = '123 Nguyễn Huệ\nQuận 1, TP. Hồ Chí Minh',
    this.paymentLast4 = '4829',
    this.paymentBrand = 'Visa',
    this.errorMessage,
    this.orderId,
  });

  double get deliveryCost => deliveryOption == 0 ? 0 : 300000;
  String get formattedDeliveryCost =>
      deliveryCost == 0 ? 'Miễn phí' : CurrencyFormatter.formatRawVnd(deliveryCost);

  CheckoutState copyWith({
    CheckoutStatus? status,
    int? deliveryOption,
    String? errorMessage,
    String? orderId,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      deliveryOption: deliveryOption ?? this.deliveryOption,
      shippingName: shippingName,
      shippingAddress: shippingAddress,
      paymentLast4: paymentLast4,
      paymentBrand: paymentBrand,
      errorMessage: errorMessage,
      orderId: orderId ?? this.orderId,
    );
  }

  @override
  List<Object?> get props => [status, deliveryOption, errorMessage, orderId];
}
