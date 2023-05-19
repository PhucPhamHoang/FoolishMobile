part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class OnClearCartState extends CartEvent{}

class OnLoadAllCartListState extends CartEvent {
  final int page;
  final int limit;

  const OnLoadAllCartListState(this.page, this.limit);
}

class OnLoadTotalCartItemQuantityState extends CartEvent {}

class OnUpdateCartState extends CartEvent {
  final List<Cart> cartItemList;

  const OnUpdateCartState(this.cartItemList);
}

class OnRemoveCartItemState extends CartEvent {
  final List<int> cartIdList;

  const OnRemoveCartItemState(this.cartIdList);
}

class OnAddCartItemState extends CartEvent {
  final int productId;
  final String color;
  final String size;
  final int quantity;

  const OnAddCartItemState(this.productId, this.color, this.size, this.quantity);
}