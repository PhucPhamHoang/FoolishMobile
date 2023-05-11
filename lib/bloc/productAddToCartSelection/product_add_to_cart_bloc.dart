import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_add_to_cart_event.dart';
part 'product_add_to_cart_state.dart';

class ProductAddToCartBloc extends Bloc<ProductAddToCartEvent, ProductAddToCartState> {
  String productName = '';
  String size= '';
  String color= '';
  int quantity = 0;

  ProductAddToCartBloc() : super(ProductAddToCartInitial()) {
    on<OnSelectProductAddToCartEvent>((event, emit) {
      if(event.productName != null && event.productName != '') {
        productName = event.productName!;
      }

      if(event.size != null && event.size != '') {
        size = event.size!;
      }

      if(event.color != null && event.color != '') {
        color = event.color!;
      }

      if(event.quantity != null && event.quantity != 0) {
        quantity = event.quantity!;
      }

      emit(ProductAddToCartLoadState(productName, size, color, quantity));
    });

    on<OnClearProductAddToCartEvent>((event, emit) {
      productName = '';
      size= '';
      color= '';
      quantity = 0;
    });
  }
}
