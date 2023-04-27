import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/presentation/layout/Layout.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, catagoryState) {
                if(catagoryState is CategoryLoadedState) {
                  print(catagoryState.categoryList);
                }

                return Container();
              }
            )
          ],
        ),
      )
    );
  }
}