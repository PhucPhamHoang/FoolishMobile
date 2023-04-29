import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/entity/Product.dart';
import '../../repository/ShopRepository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ShopRepository _shopRepository;

  Product? selectedProduct;
  List<Product>? productList;

  ProductBloc(this._shopRepository) : super(ProductInitial()) {
    on<OnSearchProductEvent>((event, emit) async {
      emit(ProductLoadingState());
      productList = [];

      try{
        List<Product> list = await _shopRepository.searchProduct(event.productName);
        productList = list;
        emit(ProductListLoadedState(list));
      }
      catch(e){
        print(e);
        emit(ProductErrorState(e.toString()));
      }
    });
  }
}
