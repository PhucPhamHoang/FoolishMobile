import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/presentation/layout/Layout.dart';
import 'package:fashionstore/util/render/UiRender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  final TextEditingController _textEditingController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Layout(
      forceCanNotBack: false,
      refreshIndicatorKey: _refreshIndicatorKey,
      scrollController: _scrollController,
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

          ],
        ),
      ),
    );
  }

  Widget _categoryList() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState) {
        if(categoryState is CategoryLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }

        return Container();
      }
    );
  }
}