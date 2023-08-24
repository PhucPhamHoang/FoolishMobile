import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/entity/product.dart';
import '../../repository/shop_repository.dart';

part 'product_searching_event.dart';
part 'product_searching_state.dart';

class ProductSearchingBloc
    extends Bloc<ProductSearchingEvent, ProductSearchingState> {
  final ShopRepository _shopRepository;

  List<Product> searchingProductList = [];
  int currentSearchingProductListPage = 1;

  ProductSearchingBloc(this._shopRepository)
      : super(ProductSearchingInitial()) {
    on<OnSearchProductEvent>((event, emit) async {
      emit(ProductSearchingLoadingState());
      searchingProductList = [];

      try {
        dynamic response = await _shopRepository.searchProduct(
            event.productName,
            page: event.page,
            limit: event.limit);

        if (response is List<Product>) {
          searchingProductList = response;
          currentSearchingProductListPage = event.page;
          emit(ProductSearchingListLoadedState(response));
        } else {
          emit(ProductSearchingErrorState(response.toString()));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(ProductSearchingErrorState(e.toString()));
      }
    });

    on<OnClearProductResultsEvent>((event, emit) {
      searchingProductList = [];
      currentSearchingProductListPage = 1;
    });
  }
}
