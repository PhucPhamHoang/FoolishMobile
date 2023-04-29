import 'package:fashionstore/bloc/products/product_bloc.dart';
import 'package:fashionstore/data/enum/ProductListTypeEnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/categories/category_bloc.dart';

class LoadingService {
  final BuildContext context;

  LoadingService(this.context);


  void reloadHomePage() {
    BlocProvider.of<CategoryBloc>(context).add(OnLoadCategoryEvent());
    BlocProvider.of<ProductBloc>(context).add(OnLoadProductListEvent(ProductListTypeEnum.HOT_DISCOUNT.name));
    BlocProvider.of<ProductBloc>(context).add(OnLoadProductListEvent(ProductListTypeEnum.NEW_ARRIVAL.name));
    BlocProvider.of<ProductBloc>(context).add(OnLoadProductListEvent(ProductListTypeEnum.TOP_SELLING.name));
  }
}