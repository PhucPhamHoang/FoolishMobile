part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();
}

class ProductInitial extends ProductState {
  @override
  List<Object> get props => [];
}

class ProductLoadingState extends ProductState {
  @override
  List<Object> get props => [];
}

class ProductListLoadedState extends ProductState {
  final List<Product> productList;

  const ProductListLoadedState(this.productList);

  @override
  List<Object> get props => [productList];
}

class ProductLoadedState extends ProductState {
  final Product product;

  const ProductLoadedState(this.product);

  @override
  List<Object> get props => [product];
}

class ProductErrorState extends ProductState {
  final String message;

  const ProductErrorState(this.message);

  @override
  List<Object> get props => [message];
}