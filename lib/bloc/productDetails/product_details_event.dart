part of 'product_details_bloc.dart';

abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object?> get props => [];
}

class OnSelectProductEvent extends ProductDetailsEvent {
  final int productId;

  const OnSelectProductEvent(this.productId);
}

class OnSelectProductColorEvent extends ProductDetailsEvent {
  final String color;

  const OnSelectProductColorEvent(this.color);
}