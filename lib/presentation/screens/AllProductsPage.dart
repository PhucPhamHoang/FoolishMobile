import 'package:carousel_slider/carousel_slider.dart';
import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/presentation/layout/Layout.dart';
import 'package:fashionstore/util/render/UiRender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/products/product_bloc.dart';
import '../../data/entity/Category.dart';
import '../../data/entity/Product.dart';
import '../components/ProductFrame.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  String _currentSelectedCategory = 'All';


  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if(_currentSelectedCategory == 'All') {
        BlocProvider.of<ProductBloc>(context).add(OnLoadAllProductListEvent(
            BlocProvider.of<ProductBloc>(context).currentAllProductListPage + 1,
            8
        ));
      }
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<ProductBloc>(context).add(const OnLoadAllProductListEvent(1, 8));
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      scrollController: _scrollController,
      scaffoldKey: _scaffoldKey,
      isAlwaysScrollable: false,
      forceCanNotBack: false,
      refreshIndicatorKey: _refreshIndicatorKey,
      textEditingController: _textEditingController,
      reload: () async {

      },
      hintSearchBarText: 'What product are you looking for?',
      onSearch: () {

      },
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _categoryList(),
            _productsList(),
            const SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }

  Widget _categoryItem(String name) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentSelectedCategory = name;
        });

        if(name == 'All') {
          BlocProvider.of<ProductBloc>(context).add(const OnLoadAllProductListEvent(1, 8));
        }
        else {

        }
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: _currentSelectedCategory != name ? Colors.white : null,
          gradient: _currentSelectedCategory == name ? UiRender.generalLinearGradient() : null,
        ),
        child: Text(
          name,
          style: TextStyle(
            fontFamily: 'Work Sans',
            fontWeight: FontWeight.w400,
            color: _currentSelectedCategory == name ? Colors.white : Colors.black
          ),
        ),
      ),
    );
  }

  Widget _categoryList() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState) {
        List<Category> categoryList = BlocProvider.of<CategoryBloc>(context).categoryList;

        if(categoryState is CategoryLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }

        if(categoryState is CategoryLoadedState) {
          categoryList = categoryState.categoryList;
        }

        if(categoryList[0].name != 'All') {
          categoryList.insert(0, Category(0, 'All', ''));
        }

        return Container(
          height: 25,
          margin: const EdgeInsets.only(bottom: 25),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              return _categoryItem(categoryList[index].name);
            }
          ),
        );
      }
    );
  }

  Widget _productsList() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, productState) {
        List<Product> productList = [];

        if(productState is ProductLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }

        if(productState is ProductAllListLoadedState) {
          productList = productState.productList;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: productList?.length ?? 0,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.65,
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 25,
          ),
          itemBuilder: (context, index) {
            return ProductComponent(product: productList![index]);
          },
        );

      }
    );
  }
}