import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../product/domain/repositories/product_repository.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc
    extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository _productRepository;

  ProductDetailBloc(this._productRepository)
      : super(const ProductDetailState()) {
    on<ProductDetailLoaded>(_onLoaded);
    on<ProductColorSelected>(_onColorSelected);
    on<ProductSizeSelected>(_onSizeSelected);
    on<ProductImageSelected>(_onImageSelected);
    on<ProductReviewSubmitted>(_onReviewSubmitted);
  }

  Future<void> _onLoaded(
      ProductDetailLoaded event, Emitter<ProductDetailState> emit) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));

    try {
      final product =
          await _productRepository.getProductById(event.productId);
      emit(state.copyWith(
        status: ProductDetailStatus.loaded,
        product: product,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductDetailStatus.error,
        errorMessage: 'Product not found: $e',
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

  Future<void> _onReviewSubmitted(
      ProductReviewSubmitted event, Emitter<ProductDetailState> emit) async {
    if (state.product == null) return;
    emit(state.copyWith(isSubmittingReview: true, errorMessage: null));

    try {
      await _productRepository.addReview(
          state.product!.id, event.rating, event.comment);
      // Reload product to get the new review and updated rating
      final product =
          await _productRepository.getProductById(state.product!.id);
      emit(state.copyWith(
        isSubmittingReview: false,
        product: product,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmittingReview: false,
        errorMessage: 'Không thể gửi đánh giá: $e',
      ));
    }
  }
}
