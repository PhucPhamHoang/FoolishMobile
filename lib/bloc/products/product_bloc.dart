import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/entity/Product.dart';
import '../../data/enum/ProductListTypeEnum.dart';
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
        emit(ProductSearchingListLoadedState(list));
      }
      catch(e){
        print(e);
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnLoadAllProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try{
        List<Product> list = await _shopRepository.getProductList(ProductListTypeEnum.ALL.name);
        allProductList = list;
        emit(ProductAllListLoadedState(list));
      }
      catch(e){
        print(e);
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnLoadHotDiscountProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try{
        List<Product> list = await _shopRepository.getProductList(ProductListTypeEnum.HOT_DISCOUNT.name);
        hotDiscountProductList = list;
        emit(ProductHotDiscountListLoadedState(list));
      }
      catch(e){
        print(e);
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnLoadNewArrivalProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try{
        List<Product> list = await _shopRepository.getProductList(ProductListTypeEnum.NEW_ARRIVAL.name);
        newArrivalProductList = list;
        emit(ProductNewArrivalListLoadedState(list));
      }
      catch(e){
        print(e);
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnLoadTopBestSellerProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try{
        List<Product> list = await _shopRepository.getProductList(ProductListTypeEnum.TOP_BEST_SELLERS.name);
        top8BestSellerProductList = list;
        emit(ProductTopBestSellerListLoadedState(list));
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
