import 'package:equatable/equatable.dart';

enum CheckoutStatus { initial, loading, placing, success, error }

class CheckoutState extends Equatable {
  final CheckoutStatus status;
  final int deliveryOption;
  final String shippingName;
  final String shippingAddress;
  final String paymentLast4;
  final String paymentBrand;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.deliveryOption = 0,
    this.shippingName = 'Sarah Johnson',
    this.shippingAddress = '123 Oak Street, Apt 4B\nPortland, OR 97201',
    this.paymentLast4 = '4829',
    this.paymentBrand = 'Visa',
  });

  double get deliveryCost => deliveryOption == 0 ? 0 : 12.00;
  String get formattedDeliveryCost =>
      deliveryCost == 0 ? 'Free' : '\$${deliveryCost.toStringAsFixed(2)}';

  CheckoutState copyWith({
    CheckoutStatus? status,
    int? deliveryOption,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      deliveryOption: deliveryOption ?? this.deliveryOption,
      shippingName: shippingName,
      shippingAddress: shippingAddress,
      paymentLast4: paymentLast4,
      paymentBrand: paymentBrand,
    );
  }

  @override
  List<Object?> get props => [status, deliveryOption];
}
