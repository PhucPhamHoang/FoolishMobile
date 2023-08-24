import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/data/entity/category.dart';
import 'package:fashionstore/utils/service/loading_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/enum/navigation_name_enum.dart';
import '../../data/static/global_variables.dart';
import '../../utils/render/ui_render.dart';
import '../../utils/render/value_render.dart';
import '../layout/layout.dart';

class AllCategoriesPage extends StatefulWidget {
  const AllCategoriesPage({super.key});

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    GlobalVariable.currentNavBarPage = NavigationNameEnum.CATEGORIES.name;

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
              ))),
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
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
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
            UiRender.buildCachedNetworkImage(
                context, ValueRender.getGoogleDriveImageUrl(category.image),
                height: 90, width: 90, borderRadius: BorderRadius.circular(8))
          ],
        ),
      ),
    );
  }

  Widget _categoryList() {
    return BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, cateState) {
      List<Category> categoryList =
          BlocProvider.of<CategoryBloc>(context).categoryList;

      if (cateState is CategoryLoadingState) {
        return UiRender.loadingCircle();
      }

      if (cateState is CategoryLoadedState) {
        categoryList = cateState.categoryList;
      }

      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categoryList.length,
          itemBuilder: (context, index) {
            return _category(categoryList[index]);
          });
    });
  }
}
