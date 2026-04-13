import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsParams {
  final String? search;
  final String? categoryId;
  final int page;
  final int limit;
  const GetProductsParams({
    this.search,
    this.categoryId,
    this.page = 1,
    this.limit = 20,
  });
}

class GetProductsUseCase extends UseCase<ProductListResponse, GetProductsParams> {
  final ProductRepository _repository;
  GetProductsUseCase(this._repository);

  @override
  Future<ProductListResponse> call(GetProductsParams params) {
    return _repository.getProducts(
      search: params.search,
      categoryId: params.categoryId,
      page: params.page,
      limit: params.limit,
    );
  }
}
