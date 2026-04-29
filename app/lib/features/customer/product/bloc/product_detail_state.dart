import 'package:equatable/equatable.dart';
import '../../../product/domain/entities/product.dart';

enum ProductDetailStatus { initial, loading, loaded, error }

class ProductDetailState extends Equatable {
  final ProductDetailStatus status;
  final Product? product;
  final int selectedColor;
  final int selectedSize;
  final int selectedImage;
  final String? errorMessage;
  final bool isSubmittingReview;

  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.selectedColor = 0,
    this.selectedSize = 2,
    this.selectedImage = 0,
    this.errorMessage,
    this.isSubmittingReview = false,
  });

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    Product? product,
    int? selectedColor,
    int? selectedSize,
    int? selectedImage,
    String? errorMessage,
    bool? isSubmittingReview,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedImage: selectedImage ?? this.selectedImage,
      errorMessage: errorMessage,
      isSubmittingReview: isSubmittingReview ?? this.isSubmittingReview,
    );
  }

  @override
  List<Object?> get props => [
        status,
        product,
        selectedColor,
        selectedSize,
        selectedImage,
        errorMessage,
        isSubmittingReview,
      ];
}
