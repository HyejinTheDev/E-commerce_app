import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(const CheckoutState()) {
    on<CheckoutStarted>(_onStarted);
    on<CheckoutDeliverySelected>(_onDeliverySelected);
    on<CheckoutOrderPlaced>(_onOrderPlaced);
  }

  void _onStarted(CheckoutStarted event, Emitter<CheckoutState> emit) {
    emit(state.copyWith(status: CheckoutStatus.initial));
  }

  void _onDeliverySelected(
      CheckoutDeliverySelected event, Emitter<CheckoutState> emit) {
    emit(state.copyWith(deliveryOption: event.option));
  }

  Future<void> _onOrderPlaced(
      CheckoutOrderPlaced event, Emitter<CheckoutState> emit) async {
    emit(state.copyWith(status: CheckoutStatus.placing));

    // Simulate order processing
    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(status: CheckoutStatus.success));
  }
}
