part of 'product_details_bloc.dart';

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();
}

class ProductDetailsInitial extends ProductDetailsState {
  @override
  List<Object> get props => [];
}

class ProductDetailsLoadingState extends ProductDetailsState {
  @override
  List<Object> get props => [];
}

class ProductDetailsLoadedState extends ProductDetailsState {
  final List<Product> productList;

  const ProductDetailsLoadedState(this.productList);

  @override
  List<Object> get props => [productList];
}

class ProductDetailsErrorState extends ProductDetailsState {
  final String message;

  const ProductDetailsErrorState(this.message);

  @override
  List<Object> get props => [message];
}


