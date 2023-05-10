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
  String selectedSize = '';
  String selectedColor = '';
  List<String> selectedImageUrlList = [];

  @override
  void initState() {
    setState(() {
      selectedColor = BlocProvider.of<ProductDetailsBloc>(context).selectedColor;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      needAppBar: false,
      needProductDetailsBottomNavBar: true,
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
              BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
                listener: (context, productState) {
                  if(productState is ProductDetailsLoadedState) {
                    setState(() {
                      selectedImageUrlList = ValueRender.getProductImageUrlListByColor(selectedColor, productState.productList);
                    });
                  }

                },
                builder: (context, productState) {
                  List<Product> selectedProductDetails = [];

                  if(productState is ProductLoadingState) {
                    return UiRender.loadingCircle();
                  }

                  if(productState is ProductDetailsLoadedState) {
                    selectedProductDetails = productState.productList;
                  }

                  if(selectedProductDetails.isNotEmpty) {
                    List<Product> colorSelectedProductList = selectedProductDetails.where((element) => element.color == selectedColor).toList();
                    List<String> productColorImageUrlList = ValueRender.getProductImagesFromDifferentColors(selectedProductDetails);
                    List<String> productColorList = ValueRender.getProductColorList(selectedProductDetails);
                    List<String> productSizeList = ValueRender.getProductSizeListByColor(selectedColor ,selectedProductDetails);

                    return Column(
                      children: [
                        _productImagesSlider(selectedImageUrlList),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                )
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _ratingStarsAndProductStatus(colorSelectedProductList),
                                  _productNameAndPrice(colorSelectedProductList),
                                  _productColors(productColorImageUrlList, productColorList, selectedProductDetails),
                                  _productSizes(productSizeList),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Item Description',
                                    style: TextStyle(
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.black
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    colorSelectedProductList[0].description,
                                    style: const TextStyle(
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                      color: Color(0xff868686),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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

  Widget _ratingStarsAndProductStatus(List<Product> colorSelectedProductList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List<Widget>.generate(
                colorSelectedProductList[0].overallRating.toInt(),
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
        colorSelectedProductList[0].availableQuantity > 0
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
    );
  }

  Widget _productNameAndPrice(List<Product> colorSelectedProductList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          colorSelectedProductList[0].name,
          maxLines: 2,
          style: const TextStyle(
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w500,
              fontSize: 18,
              height: 1.5
          ),
        ),
        colorSelectedProductList[0].discount > 0
            ? RichText(
            text: TextSpan(
                text: '\$${ValueRender.getDiscountPrice(colorSelectedProductList[0].sellingPrice, colorSelectedProductList[0].discount)}  ',
                style: const TextStyle(
                    fontFamily: 'Work Sans',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xff464646),
                    height: 1.5
                ),
                children: [
                  TextSpan(
                    text: '\$${colorSelectedProductList[0].sellingPrice.toString()}',
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
          '\$${colorSelectedProductList[0].sellingPrice.toString()}',
          style: const TextStyle(
              fontFamily: 'Sen',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Colors.red,
              height: 1.5
          ),
        ),
      ],
    );
  }

  Widget _productColors(List<String> productColorImageUrlList, List<String> productColorList, List<Product> selectedProductDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                productColorImageUrlList.length,
                    (index) {
                  return CachedNetworkImage(
                    imageUrl: productColorImageUrlList[index],
                    imageBuilder: (context, imageProvider)
                    => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = productColorList[index];
                          selectedSize = '';
                          selectedImageUrlList = ValueRender.getProductImageUrlListByColor(selectedColor, selectedProductDetails);
                        });
                      },
                      child: Container(
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
                    ),
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.orange)),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  );
                }
            )
        ),
      ],
    );
  }

  Widget _productSizes(List<String> productSizeList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        SizedBox(
          height: 50,
          child: ListView.builder(
              itemCount: productSizeList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSize = productSizeList[index];
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(right: 11),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xffc4c4c4),
                        ),
                        gradient: productSizeList[index] == selectedSize
                            ? UiRender.generalLinearGradient()
                            : null
                    ),
                    child: Text(
                      productSizeList[index].toUpperCase(),
                      style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: productSizeList[index] == selectedSize
                              ? Colors.white
                              : const Color(0xff626262)
                      ),
                    ),
                  ),
                );
              }
          ),
        )
      ],
    );
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