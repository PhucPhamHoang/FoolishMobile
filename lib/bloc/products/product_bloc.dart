import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/entity/product.dart';
import '../../data/enum/product_list_type_enum.dart';
import '../../repository/shop_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ShopRepository _shopRepository;

  List<Product> allProductList = [];
  List<Product> filteredProductList = [];
  List<Product> hotDiscountProductList = [];
  List<Product> top8BestSellerProductList = [];
  List<Product> newArrivalProductList = [];

  int currentAllProductListPage = 1;

  ProductBloc(this._shopRepository) : super(ProductInitial()) {
    on<OnLoadAllProductListEvent>((event, emit) async {
      try {
        List<Product> response =
            await _shopRepository.getAllProducts(event.page, event.limit);

        if (response.isNotEmpty) {
          emit(ProductLoadingState());
          response = _removeDuplicates([...allProductList, ...response]);

          currentAllProductListPage = event.page;
          allProductList = response;

          emit(ProductAllListLoadedState(response));
        } else {
          emit(ProductAllListLoadedState(allProductList ?? []));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnLoadHotDiscountProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try {
        dynamic response = await _shopRepository
            .getProductList(ProductListTypeEnum.HOT_DISCOUNT.name);

        if (response is List<Product>) {
          hotDiscountProductList = response;
          emit(ProductHotDiscountListLoadedState(response));
        } else {
          emit(ProductErrorState(response.toString()));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnLoadNewArrivalProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try {
        dynamic response = await _shopRepository
            .getProductList(ProductListTypeEnum.NEW_ARRIVAL.name);

        if (response is List<Product>) {
          newArrivalProductList = response;
          emit(ProductNewArrivalListLoadedState(response));
        } else {
          emit(ProductErrorState(response.toString()));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnLoadTopBestSellerProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try {
        dynamic response = await _shopRepository
            .getProductList(ProductListTypeEnum.TOP_BEST_SELLERS.name);

        if (response is List<Product>) {
          top8BestSellerProductList = response;
          emit(ProductTopBestSellerListLoadedState(response));
        } else {
          emit(ProductErrorState(response.toString()));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnClearProductListEvent>((event, emit) {
      allProductList = [];
      hotDiscountProductList = [];
      top8BestSellerProductList = [];
      newArrivalProductList = [];
    });

    on<OnLoadFilterProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try {
        List<Product> response = await _shopRepository.getFilteredProducts(
            event.page, event.limit,
            brand: event.brand,
            maxPrice: event.minPrice,
            minPrice: event.minPrice,
            categories: event.categoryList);

        filteredProductList = response;
        emit(ProductFilteredListLoadedState(response));
      } catch (e) {
        debugPrint(e.toString());
        emit(ProductErrorState(e.toString()));
      }
    });
  }

  List<Product> _removeDuplicates(List<Product> list) {
    Set<int> set = {};
    List<Product> uniqueList =
        list.where((element) => set.add(element.id)).toList();

    return uniqueList;
  }
}
