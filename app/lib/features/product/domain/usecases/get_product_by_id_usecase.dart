import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductByIdUseCase extends UseCase<Product, String> {
  final ProductRepository _repository;
  GetProductByIdUseCase(this._repository);

  @override
  Future<Product> call(String id) {
    return _repository.getProductById(id);
  }
}
