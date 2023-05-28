import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/data/entity/CartItem.dart';
import 'package:fashionstore/presentation/components/GradientButton.dart';
import 'package:fashionstore/presentation/components/IconButtonComponent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/productDetails/product_details_bloc.dart';
import '../../data/entity/Cart.dart';
import '../../data/entity/Product.dart';
import '../../util/render/UiRender.dart';
import '../../util/render/ValueRender.dart';

class CartItemDetails extends StatefulWidget {
  const CartItemDetails({Key? key, required this.selectedCartItem}): super(key: key);

  final CartItem selectedCartItem;

  @override
  State<StatefulWidget> createState() => _CartItemDetailsState();
}

class _CartItemDetailsState extends State<CartItemDetails> {
  late CartItem editedCartItem;
  final TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    editedCartItem = CartItem.clone(widget.selectedCartItem);
    quantityController.text = widget.selectedCartItem.quantity.toString();

    super.initState();
  }

  @override
  void dispose() {
    quantityController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, productDetailsState) {
        List<Product> selectedProductDetails = BlocProvider.of<ProductDetailsBloc>(context).selectedProductDetails;
        // get list of products first image from different colors
        List<String> productColorImageUrlList = [];
        // get all colors of a product
        List<String> productColorList = [];
        // get list of products size using product color
        List<String> productSizeList = ValueRender.getProductSizeListByColor(editedCartItem.color, selectedProductDetails);

        if(productDetailsState is ProductDetailsLoadingState) {}

        if(productDetailsState is ProductDetailsLoadedState) {
          selectedProductDetails = productDetailsState.productList;
          productColorList = ValueRender.getProductColorList(selectedProductDetails);
          productColorImageUrlList = ValueRender.getProductImagesFromDifferentColors(selectedProductDetails);

          if(selectedProductDetails.isNotEmpty && selectedProductDetails.length > 0) {
            return Container(
              padding: EdgeInsets.fromLTRB(30, 35, 30, MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UiRender.buildCachedNetworkImage(
                        context,
                        selectedProductDetails.where((element) => element.color == editedCartItem.color).first.image1,
                        margin: const EdgeInsets.only(right: 10),
                        width: 81,
                        height: 93,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      Expanded(
                        child: Column (
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible (
                              fit: FlexFit.loose,
                              child: Text(
                                editedCartItem.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xff626262),
                                  fontFamily: 'Work Sans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                editedCartItem.brand.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Color(0xff868686),
                                    fontFamily: 'Work Sans',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    height: 1.5
                                ),
                              ),
                            ),
                            Flexible(
                                fit: FlexFit.loose,
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: editedCartItem.discount > 0
                                          ? RichText(
                                          text: TextSpan(
                                              text: '\$${ValueRender.getDiscountPrice(editedCartItem.sellingPrice, editedCartItem.discount)}  ',
                                              style: const TextStyle(
                                                  fontFamily: 'Sen',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: Colors.red,
                                                  height: 1.5
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: '\$${editedCartItem.sellingPrice.toString()}',
                                                  style: const TextStyle(
                                                      fontFamily: 'Sen',
                                                      decoration: TextDecoration.lineThrough,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 9,
                                                      color: Color(0xffacacac)
                                                  ),
                                                )
                                              ]
                                          )
                                      )
                                          : Text(
                                        '\$ ${editedCartItem.sellingPrice}',
                                        style: const TextStyle(
                                            fontFamily: 'Sen',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: Colors.red,
                                            height: 1.5
                                        ),
                                      ),
                                    ),
                                    Expanded(child: _cartItemQuantityEditComponent())
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Colors',
                    style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Color(0xff979797)
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 5),
                      height: 48,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: productColorImageUrlList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  editedCartItem.color = productColorList[index];
                                });
                              },
                              child: UiRender.buildCachedNetworkImage(
                                context,
                                productColorImageUrlList[index],
                                height: 48,
                                width: 48,
                                borderRadius: BorderRadius.circular(8),
                                margin: const EdgeInsets.only(right: 10),
                                border: productColorList[index] == editedCartItem.color
                                    ? Border.all(color: Colors.orange)
                                    : null,
                              ),
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
                        fontSize: 15,
                        color: Color(0xff979797)
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(bottom: 30, top: 5),
                      height: 48,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: productSizeList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    editedCartItem.size = productSizeList[index];
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  alignment: Alignment.center,
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: editedCartItem.size == productSizeList[index]
                                          ? UiRender.generalLinearGradient()
                                          : null,
                                      border: Border.all(
                                          color: const Color(0xffc4c4c4)
                                      )
                                  ),
                                  child: Text(
                                    productSizeList[index].toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Work Sans',
                                        color: editedCartItem.size == productSizeList[index]
                                            ? Colors.white
                                            : Colors.black
                                    ),
                                  ),
                                )
                            );
                          }
                      )
                  ),
                  Center(
                    child: GradientElevatedButton(
                      text: 'UPDATE',
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      endColor: const Color(0xff000000),
                      beginColor: const Color(0xff8D8D8C),
                      textColor: Colors.white,
                      buttonHeight: 35,
                      buttonWidth: 150,
                      textWeight: FontWeight.w600,
                      textSize: 16,
                      borderRadiusIndex: 10,
                      buttonMargin: EdgeInsets.zero,
                      onPress: () {
                        setState(() {
                          editedCartItem.quantity = int.parse(quantityController.text);

                          BlocProvider.of<CartBloc>(context).add(
                              OnUpdateCartState([
                                Cart(
                                    editedCartItem.productId,
                                    editedCartItem.id,
                                    editedCartItem.quantity,
                                    editedCartItem.color,
                                    editedCartItem.size
                                )
                              ])
                          );

                          Navigator.pop(context);
                        });
                      },
                    ),
                  )
                ],
              ),
            );
          }
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: UiRender.loadingCircle(),
        );
      },
    );
  }

  Widget _cartItemQuantityEditComponent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButtonComponent(
          iconPath: 'assets/icon/minus_icon.png',
          onTap: () {
            setState(() {
              int quant = int.parse(quantityController.text);
              if(quant > 1) {
                quantityController.text = (quant - 1).toString();
              }
            });
          },
          borderRadius: BorderRadius.circular(50),
          backgroundColor: const Color(0xffc4c4c4),
          splashColor: Colors.white,
          iconSize: 10,
        ),
        Container(
          width: 35,
          height: 25,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          child: TextField(
            showCursor: true,
            autofocus: true,
            onSubmitted: (value) {
              try {
                int quant = int.parse(value);

                if(quant > 0) {
                  quantityController.text = value;
                }
                else {
                  quantityController.text = '1';
                  UiRender.showDialog(context, '', 'You must input a number higher than 0!');
                }
              }
              catch(e) {
                quantityController.text = widget.selectedCartItem.quantity.toString();
                UiRender.showDialog(context, '', 'You must input a number!');
              }
            },
            enableInteractiveSelection: false,
            controller: quantityController,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Color(0xff626262)
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
        IconButtonComponent(
          iconPath: 'assets/icon/plus_icon.png',
          onTap: () {
            setState(() {
              int quant = int.parse(quantityController.text);
              if(quant < 100) {
                quantityController.text = (quant + 1).toString();
              }
            });
          },
          borderRadius: BorderRadius.circular(50),
          backgroundColor: const Color(0xffc4c4c4),
          splashColor: Colors.white,
          iconSize: 10,
        ),
      ],
    );
  }
}