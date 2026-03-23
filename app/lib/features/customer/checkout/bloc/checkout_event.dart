import 'package:equatable/equatable.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();
  @override
  List<Object?> get props => [];
}

class CheckoutStarted extends CheckoutEvent {
  const CheckoutStarted();
}

class CheckoutDeliverySelected extends CheckoutEvent {
  final int option;
  const CheckoutDeliverySelected(this.option);
  @override
  List<Object?> get props => [option];
}

class CheckoutOrderPlaced extends CheckoutEvent {
  const CheckoutOrderPlaced();
}
