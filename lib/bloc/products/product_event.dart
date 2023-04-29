part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class OnSearchProductEvent extends ProductEvent{
  final String productName;

  const OnSearchProductEvent(this.productName);
}
