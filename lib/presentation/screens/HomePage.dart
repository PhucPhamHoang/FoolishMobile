import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/bloc/products/product_bloc.dart';
import 'package:fashionstore/data/entity/Category.dart';
import 'package:fashionstore/presentation/layout/Layout.dart';
import 'package:fashionstore/util/render/ValueRender.dart';
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
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<CategoryBloc>(context).add(OnLoadCategoryEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      textEditingController: _textEditingController,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, catagoryState) {
                List<Category> categoryList = BlocProvider.of<CategoryBloc>(context).categoryList;

                if(catagoryState is CategoryLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  );
                }

                if(catagoryState is CategoryLoadedState) {
                  categoryList = catagoryState.categoryList;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Container(
                      height: 90,
                      margin: const EdgeInsets.only(top: 20),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: categoryList.length,
                        itemBuilder: (context, index) {
                          return _categoryComponent(categoryList[index]);
                        }
                      ),
                    )
                  ],
                );
              }
            )
          ],
        ),
      )
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
}