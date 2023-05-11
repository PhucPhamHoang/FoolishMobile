part of 'product_add_to_cart_bloc.dart';

abstract class ProductAddToCartState extends Equatable {
  const ProductAddToCartState();
}

class ProductAddToCartInitial extends ProductAddToCartState {
  @override
  List<Object> get props => [];
}

class ProductAddToCartLoadState extends ProductAddToCartState {
  final String productName;
  final String size;
  final String color;
  final int quantity;

  const ProductAddToCartLoadState(this.productName, this.size, this.color, this.quantity);

  @override
  List<Object> get props => [productName, size, color, quantity];
}
