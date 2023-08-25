import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/bloc/products/product_bloc.dart';
import 'package:fashionstore/data/entity/category.dart';
import 'package:fashionstore/data/enum/product_list_type_enum.dart';
import 'package:fashionstore/data/static/global_variables.dart';
import 'package:fashionstore/presentation/components/gradient_button.dart';
import 'package:fashionstore/presentation/components/product_component.dart';
import 'package:fashionstore/presentation/layout/layout.dart';
import 'package:fashionstore/presentation/screens/all_products_page.dart';
import 'package:fashionstore/utils/render/value_render.dart';
import 'package:fashionstore/utils/service/loading_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/productSearching/product_searching_bloc.dart';
import '../../data/entity/product.dart';
import '../../data/enum/navigation_name_enum.dart';
import '../../utils/render/ui_render.dart';
import 'all_categories_page.dart';
import 'product_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    GlobalVariable.currentNavBarPage = NavigationNameEnum.HOME.name;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoadingService(context).reloadHomePage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      forceCanNotBack: true,
      hintSearchBarText: 'What product are you looking for?',
      textEditingController: _textEditingController,
      body: RefreshIndicator(
        onRefresh: () async {
          LoadingService(context).reloadHomePage();
        },
        color: Colors.orange,
        key: _refreshIndicatorKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header('Categories', true, action: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllCategoriesPage()),
                      (Route<dynamic> route) => false);

                  GlobalVariable.currentNavBarPage =
                      NavigationNameEnum.CATEGORIES.name;
                }),
                _categoryListComponent(),
                _header('New Arrivals', false),
                _productList(ProductListTypeEnum.NEW_ARRIVAL.name),
                _header('Best Sellers', false),
                _productList(ProductListTypeEnum.TOP_BEST_SELLERS.name),
                _header('Hot Discount', false),
                _productList(ProductListTypeEnum.HOT_DISCOUNT.name),
                Align(
                  alignment: Alignment.center,
                  child: GradientElevatedButton(
                      text: 'View all products',
                      beginColor: const Color(0xff000000),
                      endColor: const Color(0xff8D8D8C),
                      textColor: Colors.white,
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AllProductsPage()),
                        );

                        BlocProvider.of<CategoryBloc>(context)
                            .add(const OnSelectedCategoryEvent('All'));

                        GlobalVariable.currentNavBarPage =
                            NavigationNameEnum.CLOTHINGS.name;
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryComponent(Category category) {
    return GestureDetector(
      onTap: () {
        LoadingService(context).selectCategory(category);
      },
      child: UiRender.buildCachedNetworkImage(
        context,
        ValueRender.getGoogleDriveImageUrl(category.image),
        width: 90,
        height: 90,
        margin: const EdgeInsets.only(right: 13),
        borderRadius: BorderRadius.circular(8),
        content: Text(
          category.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontFamily: 'Work Sans',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
      ),
    );
  }

  Widget _header(String headerContent, bool canViewAll,
      {void Function()? action}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerContent,
            style: const TextStyle(
                fontFamily: 'Work Sans',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.5),
          ),
          canViewAll
              ? TextButton(
                  onPressed: action,
                  child: const Row(
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                            fontFamily: 'Work Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffacacac)),
                      ),
                      ImageIcon(
                          size: 18,
                          color: Color(0xffacacac),
                          AssetImage('assets/icon/right_dash_arrow_icon.png'))
                    ],
                  ))
              : Container()
        ],
      ),
    );
  }

  Widget _categoryListComponent() {
    return BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, categoryState) {
      List<Category> categoryList =
          BlocProvider.of<CategoryBloc>(context).categoryList;

      if (categoryState is CategoryLoadingState) {
        return UiRender.loadingCircle();
      }

      if (categoryState is CategoryLoadedState) {
        categoryList = categoryState.categoryList;
      }

      return Container(
        height: 90,
        margin: const EdgeInsets.only(top: 20, bottom: 35),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              return _categoryComponent(categoryList[index]);
            }),
      );
    });
  }

  Widget _productList(String type) {
    return BlocBuilder<ProductBloc, ProductState>(
        builder: (context, productState) {
      List<Product> productList = (type == 'HOT_DISCOUNT'
          ? BlocProvider.of<ProductBloc>(context).hotDiscountProductList
          : type == 'NEW_ARRIVAL'
              ? BlocProvider.of<ProductBloc>(context).newArrivalProductList
              : BlocProvider.of<ProductBloc>(context)
                  .top8BestSellerProductList);
      if (productState is ProductLoadingState) {
        return UiRender.loadingCircle();
      }

      if (productState is! ProductErrorState &&
          productState is! ProductSearchingListLoadedState &&
          productState is! ProductLoadingState) {
        switch (type) {
          case 'HOT_DISCOUNT':
            {
              productList = List.from(
                  BlocProvider.of<ProductBloc>(context).hotDiscountProductList);
              break;
            }
          case 'NEW_ARRIVAL':
            {
              productList = List.from(
                  BlocProvider.of<ProductBloc>(context).newArrivalProductList);
              break;
            }
          case 'TOP_BEST_SELLERS':
            {
              productList = List.from(BlocProvider.of<ProductBloc>(context)
                  .top8BestSellerProductList);
              break;
            }
        }
      }

      if (productList.isEmpty) {
        return const Center(
          child: Text('NOT AVAILABLE!!'),
        );
      } else {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: productList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.65,
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 25,
          ),
          itemBuilder: (context, index) {
            return ProductComponent(
              product: productList[index],
              onClick: () {
                LoadingService(context).selectToViewProduct(productList[index]);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProductDetailsPage()));
              },
            );
          },
        );
      }
    });
  }
}
