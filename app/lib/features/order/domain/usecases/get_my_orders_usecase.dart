import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetMyOrdersUseCase extends UseCase<List<Order>, NoParams> {
  final OrderRepository _repository;
  GetMyOrdersUseCase(this._repository);

  @override
  Future<List<Order>> call(NoParams params) {
    return _repository.getMyOrders();
  }
}
