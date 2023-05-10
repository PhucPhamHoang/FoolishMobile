import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/bloc/products/product_bloc.dart';
import 'package:fashionstore/data/entity/Category.dart';
import 'package:fashionstore/data/enum/ProductListTypeEnum.dart';
import 'package:fashionstore/data/static/GlobalVariable.dart';
import 'package:fashionstore/presentation/components/GradientButton.dart';
import 'package:fashionstore/presentation/components/ProductComponent.dart';
import 'package:fashionstore/presentation/layout/Layout.dart';
import 'package:fashionstore/presentation/screens/AllProductsPage.dart';
import 'package:fashionstore/util/render/ValueRender.dart';
import 'package:fashionstore/util/service/LoadingService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/productDetails/product_details_bloc.dart';
import '../../data/entity/Product.dart';
import '../../data/enum/NavigationNameEnum.dart';
import '../../util/render/UiRender.dart';
import 'AllCategoriesPage.dart';
import 'ProductDetails.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    GlobalVariable.currentPage = NavigationNameEnum.HOME.name;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoadingService(context).reloadHomePage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      forceCanNotBack: true,
      hintSearchBarText: 'What product are you looking for?',
      onSearch: () {

      },
      textEditingController: _textEditingController,

      body: RefreshIndicator(
        onRefresh: () async {
          LoadingService(context).reloadHomePage();
        },
        color: Colors.orange,
        key: _refreshIndicatorKey,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(
                    'Categories',
                    true,
                    action: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const AllCategoriesPage()),
                          (Route<dynamic> route) => false
                      );

                      GlobalVariable.currentPage = NavigationNameEnum.CATEGORIES.name;
                    }
                ),
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
                      topColor: const Color(0xff000000),
                      bottomColor: const Color(0xff8D8D8C),
                      textColor: Colors.white,
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AllProductsPage()),
                        );

                        BlocProvider.of<CategoryBloc>(context).add(const OnSelectedCategoryEvent('All'));

                        GlobalVariable.currentPage = NavigationNameEnum.CLOTHING.name;
                      }
                  ),
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
      child: CachedNetworkImage(
        imageUrl: ValueRender.getGoogleDriveImageUrl(category.image),
        imageBuilder: (context, imageProvider)
        => Container(
          alignment: Alignment.center,
          width: 90,
          margin: const EdgeInsets.only(right: 13),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(ValueRender.getGoogleDriveImageUrl(category.image))
              )
          ),
          child: Text(
            category.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: 'Work Sans',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white
            ),
          ),
        ),
        placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.orange)),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  Widget _header(String headerContent, bool canViewAll, {void Function()? action}) {
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
                height: 1.5
            ),
          ),
          canViewAll
            ? TextButton(
                  onPressed: action,
                  child: Row(
                    children: const [
                      Text(
                        'View All',
                        style: TextStyle(
                            fontFamily: 'Work Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffacacac)
                        ),
                      ),
                      ImageIcon(
                          size: 18,
                          color: Color(0xffacacac),
                          AssetImage('assets/icon/right_dash_arrow_icon.png')
                      )
                    ],
                  )
              )
            : Container()
        ],
      ),
    );
  }

  Widget _categoryListComponent() {
    return BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, categoryState) {
          List<Category> categoryList = BlocProvider.of<CategoryBloc>(context).categoryList;

          if(categoryState is CategoryLoadingState) {
            return UiRender.loadingCircle();
          }

          if(categoryState is CategoryLoadedState) {
            categoryList = categoryState.categoryList;
          }

          return Container(
            height: 90,
            margin: const EdgeInsets.only(top: 20, bottom: 35),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return _categoryComponent(categoryList[index]);
                }
            ),
          );
        }
    );
  }

  Widget _productList(String type) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, productState) {
        List<Product> productList = [];
        if(productState is ProductLoadingState) {
          return UiRender.loadingCircle();
        }
        else if(productState is! ProductErrorState) {
          switch(type) {
            case 'HOT_DISCOUNT': {
              productList = BlocProvider.of<ProductBloc>(context).hotDiscountProductList;
              break;
            }
            case 'NEW_ARRIVAL': {
              productList = BlocProvider.of<ProductBloc>(context).newArrivalProductList;
              break;
            }
            case 'TOP_BEST_SELLERS': {
              productList = BlocProvider.of<ProductBloc>(context).top8BestSellerProductList;
              break;
            }
          }
        }

        if(productList == null || productList.isEmpty) {
          return const Center(
            child: Text('NOT AVAILABLE!!'),
          );
        }
        else {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productList.length ?? 0,
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
                      MaterialPageRoute(builder: (context) => const ProductDetailsPage())
                  );
                },
              );
            },
          );
        }

      }
    );
  }
}