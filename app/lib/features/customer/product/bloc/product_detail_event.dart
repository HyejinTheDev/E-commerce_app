import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();
  @override
  List<Object?> get props => [];
}

class ProductDetailLoaded extends ProductDetailEvent {
  final String productId;
  const ProductDetailLoaded(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ProductColorSelected extends ProductDetailEvent {
  final int index;
  const ProductColorSelected(this.index);

  @override
  List<Object?> get props => [index];
}

class ProductSizeSelected extends ProductDetailEvent {
  final int index;
  const ProductSizeSelected(this.index);

  @override
  List<Object?> get props => [index];
}

class ProductImageSelected extends ProductDetailEvent {
  final int index;
  const ProductImageSelected(this.index);

  @override
  List<Object?> get props => [index];
}
