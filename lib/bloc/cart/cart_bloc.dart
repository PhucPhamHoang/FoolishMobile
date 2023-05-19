import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/entity/Cart.dart';
import '../../data/entity/CartItem.dart';
import '../../repository/CartRepository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  List<CartItem> cartItemList = [];
  int currentPage = 1;
  int totalCartItemQuantity = 0;
  List<int> removalCartIdList = [];

  CartBloc(this._cartRepository) : super(CartInitial()) {
    on<OnLoadAllCartListState>((event, emit) async {
      emit(CartLoadingState());

      try {
        List<CartItem> response = await _cartRepository.showFullCart(event.page, event.limit);

        if(event.page != currentPage) {
          cartItemList = _removeDuplicates([...cartItemList,...response]);
          currentPage = event.page;
        }
        else {
          cartItemList = response;
        }

        emit(AllCartListLoadedState(cartItemList));
      }
      catch(e) {
        print(e.toString());
        emit(CartErrorState(e.toString()));
      }
    });

    on<OnClearCartState>((event, emit) {
      cartItemList = [];
      removalCartIdList = [];
      totalCartItemQuantity = 0;
    });

    on<OnLoadTotalCartItemQuantityState>((event, emit) async {
      emit(CartLoadingState());

      try {
        String response = await _cartRepository.getTotalCartItemQuantity();
        int quantity = int.parse(response);

        totalCartItemQuantity = quantity;
        emit(TotalCartItemQuantityLoadedState(quantity));
      }
      catch(e) {
        print(e.toString());
        emit(CartErrorState(e.toString()));
      }
    });

    on<OnAddCartItemState>((event, emit) async {
      emit(CartLoadingState());

      try {
        String response = await _cartRepository.add(event.productId, event.color, event.size, event.quantity);
        emit(CartAddedState(response));
      }
      catch(e) {
        print(e.toString());
        emit(CartErrorState(e.toString()));
      }
    });

    on<OnRemoveCartItemState>((event, emit) async {
      emit(CartLoadingState());

      try {
        String response = await _cartRepository.remove(event.cartIdList);
        emit(CartRemovedState(response));
      }
      catch(e) {
        print(e.toString());
        emit(CartErrorState(e.toString()));
      }
    });

    on<OnUpdateCartState>((event, emit) async {
      emit(CartLoadingState());

      try {
        String response = await _cartRepository.update(event.cartItemList);
        emit(CartRemovedState(response));
      }
      catch(e) {
        print(e.toString());
        emit(CartErrorState(e.toString()));
      }
    });
  }

  List<CartItem> _removeDuplicates(List<CartItem> list) {
    Set<int> set = {};
    List<CartItem> uniqueList = list.where((element) => set.add(element.id)).toList();

    return uniqueList;
  }
}
