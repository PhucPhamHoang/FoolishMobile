import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/bloc/products/product_bloc.dart';
import 'package:fashionstore/data/entity/Category.dart';
import 'package:fashionstore/presentation/screens/AllProductsPage.dart';
import 'package:fashionstore/util/service/LoadingService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/enum/NavigationNameEnum.dart';
import '../../data/static/GlobalVariable.dart';
import '../../util/render/UiRender.dart';
import '../../util/render/ValueRender.dart';
import '../layout/Layout.dart';

class AllCategoriesPage extends StatefulWidget {
  const AllCategoriesPage({super.key});

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();


  @override
  void initState() {
    GlobalVariable.currentPage = NavigationNameEnum.CATEGORIES.name;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<CategoryBloc>(context).add(OnLoadCategoryEvent());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      pageName: 'Categories',
      textEditingController: _textEditingController,
      hintSearchBarText: 'What category are you looking for?',
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.orange,
        onRefresh: () async {
          BlocProvider.of<CategoryBloc>(context).add(OnLoadCategoryEvent());
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _categoryList(),
          )
          )
        ),
    );
  }

  Widget _category(Category category) {
    return GestureDetector(
      onTap: () {
        LoadingService(context).selectCategory(category);
      },
      child: Container(
        height: 90,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.only(left: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category.name,
              style: const TextStyle(
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),
            CachedNetworkImage(
              imageUrl: ValueRender.getGoogleDriveImageUrl(category.image),
              imageBuilder: (context, imageProvider)
              => Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.orange)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryList() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, cateState) {
        List<Category> categoryList = BlocProvider.of<CategoryBloc>(context).categoryList;

        if(cateState is CategoryLoadingState) {
          return UiRender.loadingCircle();
        }

        if(cateState is CategoryLoadedState) {
          categoryList = cateState.categoryList;
        }

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categoryList.length,
          itemBuilder: (context, index) {
            return _category(categoryList[index]);
          }
        );
      }
    );
  }
}