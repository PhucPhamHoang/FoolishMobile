import 'package:fashionstore/bloc/productAddToCartSelection/product_add_to_cart_bloc.dart';
import 'package:fashionstore/presentation/components/GradientButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../util/render/UiRender.dart';
import '../../util/render/ValueRender.dart';

class ProductDetailsBottomNavigationBarComponent extends StatefulWidget {
  const ProductDetailsBottomNavigationBarComponent({
    Key? key,
    this.textEditingController,
  }) : super(key: key);

  final TextEditingController? textEditingController;

  @override
  State<StatefulWidget> createState() => _ProductDetailsBottomNavigationBarComponentState();
}

class _ProductDetailsBottomNavigationBarComponentState extends State<ProductDetailsBottomNavigationBarComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      height: 65,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            iconSize: 20,
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xffa4a4a4),
            ),
            onPressed: () {
              BlocProvider.of<ProductAddToCartBloc>(context).add(OnClearProductAddToCartEvent());
              Navigator.of(context).pop();
            },
          ),
          GradientElevatedButton(
            text: 'Add to cart',
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            endColor: const Color(0xff000000),
            beginColor: const Color(0xff8D8D8C),
            textColor: Colors.white,
            buttonHeight: 35,
            buttonWidth: 180,
            textWeight: FontWeight.w600,
            textSize: 16,
            borderRadiusIndex: 5,
            buttonMargin: EdgeInsets.zero,
            onPress: () {
              String color = BlocProvider.of<ProductAddToCartBloc>(context).color;
              String productName = BlocProvider.of<ProductAddToCartBloc>(context).productName;
              String size = BlocProvider.of<ProductAddToCartBloc>(context).size;
              int quantity = BlocProvider.of<ProductAddToCartBloc>(context).quantity;

              if(color != '' && productName != '' && size != '' && quantity > 0) {
                UiRender.showConfirmDialog(
                    context,
                    needCenterMessage: false,
                    '',
                    ValueRender.getAddToCartPopupContent(productName, color, size, quantity)
                );
              }
              else {
                UiRender.showDialog(context, '', 'Please check color, quantity and size again!');
              }
            }
          ),
          GradientElevatedButton(
            text: widget.textEditingController?.text != ''
                ? 'Quantity: ${widget.textEditingController?.text}'
                : 'Input Quantity',
            endColor: const Color(0xff000000),
            beginColor: const Color(0xff8D8D8C),
            buttonWidth: 60,
            borderRadiusIndex: 5,
            buttonMargin: EdgeInsets.zero,
            textColor: Colors.white,
            onPress: () {
              UiRender.showTextFieldDialog(
                context,
                hintText: 'Your quantity...',
                needCenterText: true,
                title: 'Input the quantity you want to purchase!',
                widget.textEditingController,
              ).then((value) {
                if (value) {
                  try {
                    if(int.parse(widget.textEditingController?.text ?? '0') > 0) {
                      BlocProvider.of<ProductAddToCartBloc>(context).add(
                          OnSelectProductAddToCartEvent(
                              quantity: int.parse(widget.textEditingController?.text ?? '0')
                          )
                      );
                    }
                    else {
                      UiRender.showDialog(context, '', 'Must be higher than 0!');
                      widget.textEditingController?.text = '';
                    }
                  }
                  catch (e) {
                    UiRender.showDialog(context, '', 'Letters are not accepted!');
                    widget.textEditingController?.text = '';
                  }
                }
              });
            },
          )
        ],
      ),
    );
  }
}