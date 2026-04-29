import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/order/domain/repositories/order_repository.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final OrderRepository _orderRepository;

  CheckoutBloc(this._orderRepository) : super(const CheckoutState()) {
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

    try {
      final order = await _orderRepository.createOrder(
        addressId: 'default-address', // TODO: Replace with real address selection
        items: event.items,
        paymentMethod: '${state.paymentBrand} •••• ${state.paymentLast4}',
      );

      emit(state.copyWith(
        status: CheckoutStatus.success,
        orderId: order.id,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CheckoutStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
