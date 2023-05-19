import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashionstore/bloc/translator/translator_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/productSearching/product_searching_bloc.dart';
import '../../data/entity/Product.dart';
import '../../util/render/UiRender.dart';
import '../../util/service/LoadingService.dart';
import '../layout/Layout.dart';
import 'ProductDetails.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  final TextEditingController _searchingController = TextEditingController();
  final TextEditingController _translateController = TextEditingController();

  @override
  void dispose() {
    _searchingController.dispose();
    _translateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      textEditingController: _searchingController,
      translatorEditingController: _translateController,
      pageName: "Product Searching",
      needBottomNavBar: false,
      isSearchable: true,
      hintSearchBarText: "What product do you want to search?",
      onSearch: (text) {
        if(text.isNotEmpty) {
          BlocProvider.of<ProductSearchingBloc>(context).add(OnSearchProductEvent(text, 1, 10));
        }

        if(_searchingController.text.isEmpty) {
          BlocProvider.of<ProductSearchingBloc>(context).add(const OnSearchProductEvent('', 1, 10));
        }
      },
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocListener<TranslatorBloc, TranslatorState>(
          listener: (context, translateState) {
            if(translateState is TranslatorLoadedState) {
              BlocProvider.of<ProductSearchingBloc>(context).add(OnSearchProductEvent(translateState.content, 1, 10));
              setState(() {
                _searchingController.text = translateState.content;
              });
            }
          },
          child: BlocBuilder<ProductSearchingBloc, ProductSearchingState>(
            builder: (context, productState) {
              List<Product> productList = BlocProvider.of<ProductSearchingBloc>(context).searchingProductList;

              if(productState is ProductSearchingListLoadedState) {
                productList = productState.productList;
              }

              if(productState is ProductSearchingLoadingState) {
                return UiRender.loadingCircle();
              }

              if(productList.isNotEmpty) {
                return Container(
                  color: Colors.white,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: productList.length,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemBuilder: (context, index) {
                        return _searchingResultComponent(productList[index]);
                      }
                  ),
                );
              }
              else {
                return const Center(
                  child: Text('No result!'),
                );
              }
            },
          ),
        ),
      )
    );
  }

  Widget _searchingResultComponent(Product product) {
    return GestureDetector(
      onTap: () {
        LoadingService(context).selectToViewProduct(product);

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductDetailsPage())
        );
      },
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                )
            )
        ),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: product.image1,
              imageBuilder: (context, imageProvider)
              => Container(
                height: 80,
                width: 75,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(image: NetworkImage(product.image1))
                ),
              ),
              placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.orange)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Expanded(
              child: Text(
                '${product.name} - Color: ${product.color}',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Color(0xff868686),
                    fontFamily: 'Work Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}