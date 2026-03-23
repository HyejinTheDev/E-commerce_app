import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/mock_data.dart';
import 'categories_bloc_types.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(const CategoriesState()) {
    on<CategoriesLoaded>(_onLoaded);
  }

  Future<void> _onLoaded(
      CategoriesLoaded event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(status: CategoriesStatus.loading));

    await Future.delayed(const Duration(milliseconds: 400));

    emit(state.copyWith(
      status: CategoriesStatus.loaded,
      categories: MockData.categories,
    ));
  }
}
