import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ecommerce_app/features/customer/checkout/bloc/checkout_bloc.dart';
import 'package:ecommerce_app/features/customer/checkout/bloc/checkout_event.dart';
import 'package:ecommerce_app/features/customer/checkout/bloc/checkout_state.dart';
import 'package:ecommerce_app/features/order/domain/repositories/order_repository.dart';
import 'package:ecommerce_app/features/order/domain/entities/order.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  late CheckoutBloc checkoutBloc;
  late MockOrderRepository mockOrderRepository;

  setUpAll(() {
    registerFallbackValue('fallback');
    registerFallbackValue(<Map<String, dynamic>>[]);
  });

  setUp(() {
    mockOrderRepository = MockOrderRepository();
    checkoutBloc = CheckoutBloc(mockOrderRepository);
  });

  tearDown(() {
    checkoutBloc.close();
  });

  group('CheckoutBloc Tests', () {
    test('initial state should have status initial', () {
      expect(checkoutBloc.state.status, CheckoutStatus.initial);
    });

    blocTest<CheckoutBloc, CheckoutState>(
      'emits [initial] when CheckoutStarted is added',
      build: () => checkoutBloc,
      act: (bloc) => bloc.add(const CheckoutStarted()),
      expect: () => [
        const CheckoutState(status: CheckoutStatus.initial),
      ],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'emits state with new deliveryOption when CheckoutDeliverySelected is added',
      build: () => checkoutBloc,
      act: (bloc) => bloc.add(const CheckoutDeliverySelected(1)),
      expect: () => [
        const CheckoutState(deliveryOption: 1),
      ],
    );

    final mockOrder = Order(
      id: 'ORDER_123',
      date: '2026-05-07',
      status: OrderStatus.pending,
      totalAmount: 100000,
      itemCount: 2,
      deliveryEstimate: '10/05/2026',
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'emits [placing, success] when CheckoutOrderPlaced succeeds',
      build: () {
        when(() => mockOrderRepository.createOrder(
              addressId: any(named: 'addressId'),
              items: any(named: 'items'),
              paymentMethod: any(named: 'paymentMethod'),
            )).thenAnswer((_) async => mockOrder);
        return checkoutBloc;
      },
      act: (bloc) => bloc.add(const CheckoutOrderPlaced(items: [])),
      expect: () => [
        const CheckoutState(status: CheckoutStatus.placing),
        const CheckoutState(
          status: CheckoutStatus.success,
          orderId: 'ORDER_123',
        ),
      ],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'emits [placing, error] when CheckoutOrderPlaced fails',
      build: () {
        when(() => mockOrderRepository.createOrder(
              addressId: any(named: 'addressId'),
              items: any(named: 'items'),
              paymentMethod: any(named: 'paymentMethod'),
            )).thenThrow(Exception('Failed to place order'));
        return checkoutBloc;
      },
      act: (bloc) => bloc.add(const CheckoutOrderPlaced(items: [])),
      expect: () => [
        const CheckoutState(status: CheckoutStatus.placing),
        const CheckoutState(
          status: CheckoutStatus.error,
          errorMessage: 'Failed to place order',
        ),
      ],
    );
  });
}
