import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashionstore/data/entity/CartItem.dart';
import 'package:fashionstore/util/render/UiRender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cart/cart_bloc.dart';
import '../../util/render/ValueRender.dart';

class CartItemComponent extends StatefulWidget {
  const CartItemComponent({super.key, required this.cartItem, required this.onTap,});

  final CartItem cartItem;
  final void Function() onTap;

  @override
  State<StatefulWidget> createState() => _CartItemComponentState();
}

class _CartItemComponentState extends State<CartItemComponent> {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: const Color(0xff868686)
              ),
            ),
            child: Row(
              children: [
                UiRender.buildCachedNetworkImage(
                  context,
                  widget.cartItem.image1,
                  margin: const EdgeInsets.only(right: 10),
                  width: 100,
                  height: 80,
                  borderRadius: BorderRadius.circular(8),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                widget.cartItem.name +
                                    (widget.cartItem.size.toLowerCase() != 'none'
                                        ? ' - Size: ${widget.cartItem.size.toUpperCase()} '
                                        : ''),
                                maxLines: 2,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Color(0xff626262),
                                  fontFamily: 'Work Sans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Text(
                              widget.cartItem.brand.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Color(0xff868686),
                                  fontFamily: 'Work Sans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  height: 1.5
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.cartItem.discount > 0
                                ? RichText(
                                text: TextSpan(
                                    text: '\$${ValueRender.getDiscountPrice(widget.cartItem.sellingPrice, widget.cartItem.discount)}  ',
                                    style: const TextStyle(
                                        fontFamily: 'Sen',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.red,
                                        height: 1.5
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '\$${widget.cartItem.sellingPrice.toString()}',
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
                              '\$ ${widget.cartItem.sellingPrice}',
                              style: const TextStyle(
                                  fontFamily: 'Sen',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.red,
                                  height: 1.5
                              ),
                            ),
                            Text(
                              'Quantity: ${widget.cartItem.quantity}',
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Color(0xff626262),
                                fontFamily: 'Work Sans',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
              top: -8,
              right: -20,
              child: Container(
                color: const Color(0xfff3f3f3),
                child: IconButton(
                  onPressed: () {
                    BlocProvider.of<CartBloc>(context).add(OnRemoveCartItemState([widget.cartItem.id]));
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Image.asset(
                    'assets/icon/x_icon.png',
                    color: Colors.black45,
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}