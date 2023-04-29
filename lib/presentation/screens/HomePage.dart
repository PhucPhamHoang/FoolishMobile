import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/bloc/products/product_bloc.dart';
import 'package:fashionstore/data/entity/Category.dart';
import 'package:fashionstore/presentation/layout/Layout.dart';
import 'package:fashionstore/util/render/ValueRender.dart';
import 'package:fashionstore/util/service/LoadingService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoadingService(context).reloadHomePage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      reload: () async {
        LoadingService(context).reloadHomePage();
      },
      refreshIndicatorKey: _refreshIndicatorKey,
      scrollController: _scrollController,
      textEditingController: _textEditingController,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(
              'Categories',
              true,
              action: () {

              }
            ),
            _categoryListComponent(),
            _header('Hot Discount', false),
          ],
        ),
      ),
    );
  }


  Widget _categoryComponent(Category category) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
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
    );
  }

  Widget _header(String headerContent, bool canViewAll, {void Function()? action}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          headerContent,
          style: const TextStyle(
              fontFamily: 'Work Sans',
              fontSize: 18,
              fontWeight: FontWeight.w600
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
    );
  }

  Widget _categoryListComponent() {
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


        return Container();
      }
    );
  }
}