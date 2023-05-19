part of 'product_searching_bloc.dart';

abstract class ProductSearchingState extends Equatable {
  const ProductSearchingState();
}

class ProductSearchingInitial extends ProductSearchingState {
  @override
  List<Object> get props => [];
}

class ProductSearchingLoadingState extends ProductSearchingState {
  @override
  List<Object> get props => [];
}

class ProductSearchingListLoadedState extends ProductSearchingState {
  final List<Product> productList;

  const ProductSearchingListLoadedState(this.productList);

  @override
  List<Object> get props => [productList];
}

class ProductSearchingErrorState extends ProductSearchingState {
  final String message;

  const ProductSearchingErrorState(this.message);

  @override
  List<Object> get props => [message];
}