part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();
}

class CartInitial extends CartState {
  @override
  List<Object> get props => [];
}

class CartLoadingState extends CartState {
  @override
  List<Object> get props => [];
}

class AllCartListLoadedState extends CartState {
  final List<CartItem> cartItemList;

  const AllCartListLoadedState(this.cartItemList);

  @override
  List<Object> get props => [cartItemList];
}

class TotalCartItemQuantityLoadedState extends CartState {
  final int totalQuantity;

  const TotalCartItemQuantityLoadedState(this.totalQuantity);

  @override
  List<Object> get props => [totalQuantity];
}

class CartAddedState extends CartState {
  final String message;

  const CartAddedState(this.message);

  @override
  List<Object> get props => [message];
}

class CartRemovedState extends CartState {
  final String message;

  const CartRemovedState(this.message);

  @override
  List<Object> get props => [message];
}

class CartUpdatedState extends CartState {
  final String message;

  const CartUpdatedState(this.message);

  @override
  List<Object> get props => [message];
}

class CartErrorState extends CartState {
  final String message;

  const CartErrorState(this.message);

  @override
  List<Object> get props => [message];
}