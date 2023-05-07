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

  int currentAllProductListPage = 1;

  ProductBloc(this._shopRepository) : super(ProductInitial()) {
    on<OnSearchProductEvent>((event, emit) async {
      emit(ProductLoadingState());
      searchingProductList = [];

      try{
        dynamic response = await _shopRepository.searchProduct(event.productName);

        if(response is List<Product>) {
          searchingProductList = response;
          emit(ProductSearchingListLoadedState(response));
        }
        else {
          emit(ProductErrorState(response.toString()));
        }
      }
      catch(e){
        print(e);
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnLoadAllProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try{
        dynamic response = await _shopRepository.getAllProducts(event.page, event.limit);

        if(response is List<Product> && response.isNotEmpty) {
          allProductList = _removeDuplicates([...?allProductList,...response]);
          currentAllProductListPage = event.page;
        }
        emit(ProductAllListLoadedState(allProductList ?? []));
      }
      catch(e){
        print(e);
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnLoadHotDiscountProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try{
        dynamic response = await _shopRepository.getProductList(ProductListTypeEnum.HOT_DISCOUNT.name);

        if(response is List<Product>) {
          hotDiscountProductList = response;
          emit(ProductHotDiscountListLoadedState(response));
        }
        else {
          emit(ProductErrorState(response.toString()));
        }
      }
      catch(e){
        print(e);
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnLoadNewArrivalProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try{
        dynamic response = await _shopRepository.getProductList(ProductListTypeEnum.NEW_ARRIVAL.name);

        if(response is List<Product>) {
          newArrivalProductList = response;
          emit(ProductNewArrivalListLoadedState(response));
        }
        else {
          emit(ProductErrorState(response.toString()));
        }
      }
      catch(e){
        print(e);
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnLoadTopBestSellerProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try{
        dynamic response = await _shopRepository.getProductList(ProductListTypeEnum.TOP_BEST_SELLERS.name);

        if(response is List<Product>) {
          top8BestSellerProductList = response;
          emit(ProductTopBestSellerListLoadedState(response));
        }
        else {
          emit(ProductErrorState(response.toString()));
        }
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

  List<Product> _removeDuplicates(List<Product> list) {
    Set<int> set = {};
    List<Product> uniqueList = list.where((element) => set.add(element.id),).toList();

    return uniqueList;
  }
}
