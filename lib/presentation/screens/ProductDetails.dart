import 'package:fashionstore/bloc/products/product_bloc.dart';
import 'package:fashionstore/presentation/layout/Layout.dart';
import 'package:fashionstore/util/render/UiRender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/productDetails/product_details_bloc.dart';
import '../../data/entity/Product.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  CarouselController carouselController = CarouselController();


  @override
  Widget build(BuildContext context) {
    return Layout(
      scaffoldKey: _scaffoldKey,
      textEditingController: _textEditingController,
      body: RefreshIndicator(
        onRefresh: () async {

        },
        color: Colors.orange,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                builder: (context, productState) {
                  List<Product> selectedProductDetails = BlocProvider.of<ProductDetailsBloc>(context).selectedProductDetails;
                  String selectColor = BlocProvider.of<ProductDetailsBloc>(context).selectedColor;

                  if(productState is ProductLoadingState) {
                    return UiRender.loadingCircle();
                  }

                  if(productState is ProductDetailsLoadedState) {
                    selectedProductDetails = productState.productList;
                  }

                  if(selectedProductDetails.isNotEmpty) {
                    List<Product> tempList = selectedProductDetails.where((element) => element.color == selectColor).toList();

                    List<String> imageUrlList = [tempList[0].image1, tempList[0].image2, tempList[0].image3, tempList[0].image4];

                    return Column(
                      children: [
                        CarouselSlider(
                          carouselController: carouselController,
                          items: _imageComponentList(imageUrlList),
                          options: CarouselOptions(
                            enableInfiniteScroll: true,
                            height: MediaQuery.of(context).size.height * 3/5,
                            viewportFraction: 1
                          ),
                        )
                      ],
                    );
                  }
                  else {
                    return Container();
                  }
                }
              )
            ],
          ),
        ),
      )
    );
  }

  List<Widget> _imageComponentList(List<String> imageUrlList) {
    List<Widget> resultList = [];

    for(int i = 0; i < imageUrlList.length; i++) {
      resultList.add(_imageComponent(imageUrlList[i]));
    }

    return resultList;
  }

  Widget _imageComponent(String imageUrl) {
    return Container(
      height: MediaQuery.of(context).size.height * 3/5,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(imageUrl)
        )
      ),
    );
  }
}