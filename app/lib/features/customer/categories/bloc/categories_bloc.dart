import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/repositories/category_repository.dart';
import 'categories_bloc_types.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoryRepository _categoryRepository;

  CategoriesBloc(this._categoryRepository) : super(const CategoriesState()) {
    on<CategoriesLoaded>(_onLoaded);
  }

  Future<void> _onLoaded(
      CategoriesLoaded event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(status: CategoriesStatus.loading));

    try {
      final categories = await _categoryRepository.getCategories();
      emit(state.copyWith(
        status: CategoriesStatus.loaded,
        categories: categories,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CategoriesStatus.error,
      ));
    }
  }
}
