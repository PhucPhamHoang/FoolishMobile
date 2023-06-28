import 'package:json_annotation/json_annotation.dart';

import '../static/GlobalVariable.dart';

part 'CartItemInfo.g.dart';

@JsonSerializable()
class CartItemInfo {
  final int productId;
  final int cartId;
  final int quantity;
  final String color;
  final String size;
  final int selectStatus;

  CartItemInfo(this.productId, this.cartId, this.quantity, this.color, this.size, this.selectStatus);

  factory CartItemInfo.fromJson(Map<String, dynamic> json) => _$CartItemInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemInfoToJson(this);

  @override
  String toString() {
    return 'CartItemInfo{productId: $productId, cartId: $cartId, quantity: $quantity, color: $color, size: $size, selectStatus: $selectStatus}';
  }
}