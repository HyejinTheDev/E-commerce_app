import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/mock_data.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc
    extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc() : super(const ProductDetailState()) {
    on<ProductDetailLoaded>(_onLoaded);
    on<ProductColorSelected>(_onColorSelected);
    on<ProductSizeSelected>(_onSizeSelected);
    on<ProductImageSelected>(_onImageSelected);
  }

  Future<void> _onLoaded(
      ProductDetailLoaded event, Emitter<ProductDetailState> emit) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));

    await Future.delayed(const Duration(milliseconds: 400));

    try {
      final product = MockData.featuredProducts.firstWhere(
        (p) => p.id == event.productId,
        orElse: () => MockData.featuredProducts.first,
      );
      emit(state.copyWith(
        status: ProductDetailStatus.loaded,
        product: product,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductDetailStatus.error,
        errorMessage: 'Product not found',
      ));
    }
  }

  void _onColorSelected(
      ProductColorSelected event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(selectedColor: event.index));
  }

  void _onSizeSelected(
      ProductSizeSelected event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(selectedSize: event.index));
  }

  void _onImageSelected(
      ProductImageSelected event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(selectedImage: event.index));
  }
}
