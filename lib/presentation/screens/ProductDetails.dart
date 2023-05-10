import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashionstore/bloc/products/product_bloc.dart';
import 'package:fashionstore/presentation/layout/Layout.dart';
import 'package:fashionstore/util/render/UiRender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/productDetails/product_details_bloc.dart';
import '../../data/entity/Product.dart';
import '../../util/render/ValueRender.dart';

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
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          child: Column(
            children: [
              BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                builder: (context, productState) {
                  List<Product> selectedProductDetails = [];
                  String selectedColor = BlocProvider.of<ProductDetailsBloc>(context).selectedColor;

                  if(productState is ProductLoadingState) {
                    return UiRender.loadingCircle();
                  }

                  if(productState is ProductDetailsLoadedState) {
                    selectedProductDetails = productState.productList;
                  }

                  if(selectedProductDetails.isNotEmpty) {
                    List<Product> coloredSelectedProductList = selectedProductDetails.where((element) => element.color == selectedColor).toList();
                    List<String> productColorList = ValueRender.getProductImagesFromDifferentColors(selectedProductDetails);
                    List<String> productSizeList = ValueRender.getProductSizeListByColor(selectedColor ,selectedProductDetails);
                    List<String> imageUrlList = [coloredSelectedProductList[0].image1, coloredSelectedProductList[0].image2, coloredSelectedProductList[0].image3, coloredSelectedProductList[0].image4];

                    return Column(
                      children: [
                        _productImagesSlider(imageUrlList),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: List<Widget>.generate(
                                        coloredSelectedProductList[0].overallRating.toInt(),
                                        (index) {
                                          return Container(
                                            height: 16,
                                            width: 16,
                                            margin: const EdgeInsets.fromLTRB(0, 9, 2, 10),
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage('assets/icon/star_icon.png')
                                                )
                                            ),
                                          );
                                        }
                                    )
                                  ),
                                  coloredSelectedProductList[0].availableQuantity > 0
                                   ? const Text(
                                       'In Stock',
                                        style: TextStyle(
                                          fontFamily: 'Work Sans',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Color(0xff03A600)
                                        ),
                                     )
                                   : Container()
                                ],
                              ),
                              Text(
                                coloredSelectedProductList[0].name,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontFamily: 'Work Sans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  height: 1.5
                                ),
                              ),
                              coloredSelectedProductList[0].discount > 0
                                ? RichText(
                                  text: TextSpan(
                                      text: '\$${ValueRender.getDiscountPrice(coloredSelectedProductList[0].sellingPrice, coloredSelectedProductList[0].discount)}  ',
                                      style: const TextStyle(
                                          fontFamily: 'Work Sans',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Color(0xff464646),
                                          height: 1.5
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '\$${coloredSelectedProductList[0].sellingPrice.toString()}',
                                          style: const TextStyle(
                                              fontFamily: 'Work Sans',
                                              decoration: TextDecoration.lineThrough,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              color: Color(0xffacacac)
                                          ),
                                        )
                                      ]
                                  )
                                )
                                : Text(
                                  '\$${coloredSelectedProductList[0].sellingPrice.toString()}',
                                  style: const TextStyle(
                                    fontFamily: 'Sen',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Colors.red,
                                    height: 1.5
                                  ),
                                ),
                              const SizedBox(height: 25),
                              const Text(
                                'Colors',
                                style: TextStyle(
                                    fontFamily: 'Work Sans',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xffa4a4a4),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List<Widget>.generate(
                                    productColorList.length,
                                    (index) {
                                      return CachedNetworkImage(
                                        imageUrl: productColorList[index],
                                        imageBuilder: (context, imageProvider)
                                        => Container(
                                          height: 50,
                                          width: 50,
                                          margin: const EdgeInsets.only(right: 11, top: 14),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.orange)),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      );
                                    }
                                )
                              ),
                              const SizedBox(height: 25),
                              const Text(
                                'Sizes',
                                style: TextStyle(
                                  fontFamily: 'Work Sans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color(0xffa4a4a4),
                                ),
                              ),
                              // build ListView cho Size của sản phầm
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  else {
                    return Container();
                  }
                }
              ),
              
            ],
          ),
        ),
      )
    );
  }

  Widget _productOtherDetailsAndSelection() {
    return Container();
  }

  Widget _productImagesSlider(List<String> imageUrlList) {
    return CarouselSlider(
      carouselController: carouselController,
      items: _imageComponentList(imageUrlList),
      options: CarouselOptions(
          enableInfiniteScroll: true,
          height: MediaQuery.of(context).size.height * 3/5,
          viewportFraction: 1
      ),
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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 3/5,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider)
          => Container(
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
    );
  }
}