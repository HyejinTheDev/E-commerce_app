import '../../../../core/usecases/usecase.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase extends UseCase<List<Category>, NoParams> {
  final CategoryRepository _repository;
  GetCategoriesUseCase(this._repository);

  @override
  Future<List<Category>> call(NoParams params) {
    return _repository.getCategories();
  }
}
