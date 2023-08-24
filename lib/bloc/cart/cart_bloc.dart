import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashionstore/data/enum/cart_enum.dart';
import 'package:flutter/cupertino.dart';

import '../../data/entity/cart_item.dart';
import '../../data/entity/cart_item_info.dart';
import '../../repository/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  List<CartItem> cartItemList = [];
  int currentPage = 1;
  int totalCartItemQuantity = 0;
  List<int> removalCartIdList = [];

  CartBloc(this._cartRepository) : super(CartInitial()) {
    on<OnLoadAllCartListEvent>((event, emit) async {
      emit(CartLoadingState());

      try {
        List<CartItem> response =
            await _cartRepository.showFullCart(event.page, event.limit);

        if (event.page != currentPage) {
          cartItemList = _removeDuplicates([...cartItemList, ...response]);
          currentPage = event.page;
        } else {
          cartItemList = response;
        }

        emit(AllCartListLoadedState(cartItemList));
      } catch (e) {
        debugPrint(e.toString());
        emit(CartErrorState(e.toString()));
      }
    });

    on<OnClearCartEvent>((event, emit) {
      cartItemList = [];
      removalCartIdList = [];
      totalCartItemQuantity = 0;
    });

    on<OnLoadTotalCartItemQuantityEvent>((event, emit) async {
      emit(CartLoadingState());

      try {
        String response = await _cartRepository.getTotalCartItemQuantity();
        int quantity = int.parse(response);

        totalCartItemQuantity = quantity;
        emit(TotalCartItemQuantityLoadedState(quantity));
      } catch (e) {
        debugPrint(e.toString());
        emit(CartErrorState(e.toString()));
      }
    });

    on<OnAddCartItemEvent>((event, emit) async {
      emit(CartLoadingState());

      try {
        String response = await _cartRepository.add(
            event.productId, event.color, event.size, event.quantity);
        emit(CartAddedState(response));
      } catch (e) {
        debugPrint(e.toString());
        emit(CartErrorState(e.toString()));
      }
    });

    on<OnRemoveCartItemEvent>((event, emit) async {
      emit(CartLoadingState());

      try {
        String response = await _cartRepository.remove(event.cartIdList);
        emit(CartRemovedState(response));
      } catch (e) {
        debugPrint(e.toString());
        emit(CartErrorState(e.toString()));
      }
    });

    on<OnUpdateCartEvent>((event, emit) async {
      if (event.needReload == true) {
        emit(CartLoadingState());

        try {
          String response = await _cartRepository.update(event.cartItemList);
          emit(CartUpdatedState(response));
        } catch (e) {
          debugPrint(e.toString());
          emit(CartErrorState(e.toString()));
        }
      } else {
        try {
          String response = await _cartRepository.update(event.cartItemList);
          emit(CartSelectedState());
        } catch (e) {
          debugPrint(e.toString());
          emit(CartErrorState(e.toString()));
        }
      }
    });

    on<OnFilterCartEvent>((event, emit) async {
      emit(CartLoadingState());

      try {
        List<CartItem> response = await _cartRepository.filterCartItems(
            event.name, event.status, event.brand, event.page, event.limit);

        if (event.page != null) {
          if (event.page != currentPage) {
            cartItemList = _removeDuplicates([...cartItemList, ...response]);
            currentPage = event.page ?? currentPage;
          }
        } else {
          cartItemList = response;
        }

        if (event.name == null &&
            event.brand == null &&
            event.status == [CartEnum.SELECTED.name]) {
          emit(CartFilteredToCheckoutState(cartItemList));
        } else {
          emit(CartFilteredState(cartItemList));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(CartErrorState(e.toString()));
      }
    });
  }

  List<CartItem> _removeDuplicates(List<CartItem> list) {
    Set<int> set = {};
    List<CartItem> uniqueList =
        list.where((element) => set.add(element.id)).toList();

    return uniqueList;
  }
}
