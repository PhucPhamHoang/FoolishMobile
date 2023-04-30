import 'package:fashionstore/data/entity/Product.dart';
import 'package:flutter/cupertino.dart';

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
        maxHeight: 220,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        ],
      ),
    );
  }
}