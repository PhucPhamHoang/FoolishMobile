import 'package:fashionstore/data/entity/Product.dart';
import 'package:fashionstore/util/render/UiRender.dart';
import 'package:fashionstore/util/render/ValueRender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductComponent extends StatefulWidget {
  const ProductComponent({
    Key? key,
    required this.product,
    this.onClick
  }) : super(key: key);

  final Product product;
  final void Function()? onClick;

  @override
  State<StatefulWidget> createState()  => _ProductComponentState();
}

class _ProductComponentState extends State<ProductComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - 34,
        constraints: const BoxConstraints(
          maxHeight: 500,
        ),
        child: Stack(
          children: [
            Column(
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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List<Widget>.generate(
                              widget.product.overallRating.toInt(),
                                  (index) {
                                return Container(
                                  height: 10,
                                  width: 10,
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
                      widget.product.discount > 0
                          ? RichText(
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
                          : Text(
                        '\$${widget.product.sellingPrice.toString()}',
                        style: const TextStyle(
                            fontFamily: 'Sen',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.red,
                            height: 1.5
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            widget.product.discount > 0
            ? Positioned(
                left: 0,
                top: 23,
                child: Container(
                  alignment: Alignment.center,
                  width: 50,
                  height: 23,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      gradient: UiRender.generalLinearGradient()
                  ),
                  child: Text(
                    '-${widget.product.discount}%',
                    style: const TextStyle(
                      fontFamily: 'Sen',
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                )
              )
            : Container(),
          ]
        ),
      ),
    );
  }
}