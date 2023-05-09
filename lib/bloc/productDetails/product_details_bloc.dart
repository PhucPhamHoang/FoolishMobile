import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/entity/Product.dart';
import '../../repository/ShopRepository.dart';
import '../products/product_bloc.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final ShopRepository _shopRepository;
  List<Product> selectedProductDetails = [];

  String selectedColor = '';

  ProductDetailsBloc(this._shopRepository) : super(ProductDetailsInitial()) {
    on<OnSelectProductEvent>((event, emit) async {
      emit(ProductDetailsLoadingState());

      try {
        List<Product> response = await _shopRepository.getProductDetails(event.productId);
        selectedProductDetails = response;
        emit(ProductDetailsLoadedState(response));
      }
      catch(e) {
        print(e);
        emit(ProductDetailsErrorState(e.toString()));
      }
    });

    on<OnSelectProductColorEvent>((event, emit) {
      selectedColor = event.color;
    });
  }
}
