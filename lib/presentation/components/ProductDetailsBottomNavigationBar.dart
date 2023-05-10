import 'package:fashionstore/presentation/components/GradientButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/render/UiRender.dart';

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

            }
          ),
          GestureDetector(
            onTap: () {
              UiRender.showTextFieldDialog(context, widget.textEditingController);
            },
            child: SizedBox(
              width: 57,
              child: Text(
                widget.textEditingController?.text != ''
                    ? 'Quantity: ${widget.textEditingController?.text}'
                    : 'Input Quantity',
                textAlign: TextAlign.center,
              )
            ),
          )
        ],
      ),
    );
  }
}