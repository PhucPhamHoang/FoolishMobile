import 'package:fashionstore/bloc/products/product_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/categories/category_bloc.dart';
import '../../bloc/productDetails/product_details_bloc.dart';
import '../../data/entity/Category.dart';
import '../../data/entity/Product.dart';
import '../../presentation/screens/AllProductsPage.dart';

class LoadingService {
  final BuildContext context;

  LoadingService(this.context);


  void reloadHomePage() {
    BlocProvider.of<CategoryBloc>(context).add(OnLoadCategoryEvent());
    BlocProvider.of<ProductBloc>(context).add(const OnLoadNewArrivalProductListEvent());
    BlocProvider.of<ProductBloc>(context).add(const OnLoadTopBestSellerProductListEvent());
    BlocProvider.of<ProductBloc>(context).add(const OnLoadHotDiscountProductListEvent());
  }

  void selectToViewProduct(Product product) {
    BlocProvider.of<ProductDetailsBloc>(context).add(OnSelectProductEvent(product.productId));
    BlocProvider.of<ProductDetailsBloc>(context).add(OnSelectProductColorEvent(product.color));
  }

  void selectCategory(Category category) {
    BlocProvider.of<ProductBloc>(context).add(
        OnLoadFilterProductListEvent(
            1,
            8,
            categoryList: [category.name]
        )
    );

    BlocProvider.of<CategoryBloc>(context).add(OnSelectedCategoryEvent(category.name));

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AllProductsPage(isFromCategoryPage: true,)),
            (Route<dynamic> route) => false
    );
  }
}