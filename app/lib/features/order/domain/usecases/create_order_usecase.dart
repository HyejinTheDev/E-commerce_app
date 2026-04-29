import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class CreateOrderParams {
  final String addressId;
  final List<Map<String, dynamic>> items;
  final String? paymentMethod;
  final String? note;

  const CreateOrderParams({
    required this.addressId,
    required this.items,
    this.paymentMethod,
    this.note,
  });
}

class CreateOrderUseCase extends UseCase<Order, CreateOrderParams> {
  final OrderRepository _repository;
  CreateOrderUseCase(this._repository);

  @override
  Future<Order> call(CreateOrderParams params) {
    return _repository.createOrder(
      addressId: params.addressId,
      items: params.items,
      paymentMethod: params.paymentMethod,
      note: params.note,
    );
  }
}
