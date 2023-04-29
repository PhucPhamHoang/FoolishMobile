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
  List<Product>? allProductList;
  List<Product>? hotDiscountProductList;
  List<Product>? top8BestSellerProductList;
  List<Product>? newArrivalProductList;
  List<Product>? searchingProductList;

  ProductBloc(this._shopRepository) : super(ProductInitial()) {
    on<OnSearchProductEvent>((event, emit) async {
      emit(ProductLoadingState());
      searchingProductList = [];

      try{
        List<Product> list = await _shopRepository.searchProduct(event.productName);
        searchingProductList = list;
        emit(ProductListLoadedState(list));
      }
      catch(e){
        print(e);
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnLoadProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try{
        List<Product> list = await _shopRepository.getProductList(event.type);

        switch(event.type) {
          case 'NEW_ARRIVAL': {
            newArrivalProductList = list;
            break;
          }
          case 'TOP_SELLING': {
            top8BestSellerProductList = list;
            break;
          }
          case 'HOT_DISCOUNT': {
            hotDiscountProductList = list;
            break;
          }
          case 'ALL': {
            allProductList = list;
            break;
          }
        }

        emit(ProductListLoadedState(list));
      }
      catch(e){
        print(e);
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnClearProductListEvent>((event, emit) {
      allProductList = [];
      hotDiscountProductList = [];
      top8BestSellerProductList = [];
      newArrivalProductList = [];
      searchingProductList = [];
    });
  }
}
