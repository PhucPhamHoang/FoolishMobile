import 'package:fashionstore/data/entity/Product.dart';
import 'package:fashionstore/util/render/ValueRender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductComponent extends StatefulWidget {
  const ProductComponent({
    Key? key,
    required this.product
  }) : super(key: key);

  final Product product;

  @override
  State<StatefulWidget> createState()  => _ProductComponentState();
}

class _ProductComponentState extends State<ProductComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width / 2) - 34,
      constraints: const BoxConstraints(
        maxHeight: 500,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              // height: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(widget.product.image1),
                  fit: BoxFit.cover
                )
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                      fontFamily: 'Work Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff464646)
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: '\$${ValueRender.getDiscountPrice(widget.product.sellingPrice, widget.product.discount)}  ',
                    style: const TextStyle(
                      fontFamily: 'Sen',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.red,
                      height: 1.5
                    ),
                    children: [
                      TextSpan(
                        text: '\$${widget.product.sellingPrice.toString()}',
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
              ],
            ),
          )
        ],
      ),
    );
  }
}