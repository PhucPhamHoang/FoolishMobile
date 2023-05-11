part of 'product_add_to_cart_bloc.dart';

abstract class ProductAddToCartEvent extends Equatable {
  const ProductAddToCartEvent();

  @override
  List<Object> get props => [];
}

class OnSelectProductAddToCartEvent extends ProductAddToCartEvent {
  final String? productName;
  final String? size;
  final String? color;
  final int? quantity;

  const OnSelectProductAddToCartEvent({this.productName, this.size, this.color, this.quantity});
}

class OnClearProductAddToCartEvent extends ProductAddToCartEvent {}