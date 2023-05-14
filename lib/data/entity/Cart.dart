import 'package:json_annotation/json_annotation.dart';

part 'Cart.g.dart';

@JsonSerializable()
class Cart {
  final int productId;
  final int cartId;
  final int quantity;
  final String color;
  final String size;

  Cart(this.productId, this.cartId, this.quantity, this.color, this.size);

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  Map<String, dynamic> toJson() => _$CartToJson(this);

  @override
  String toString() {
    return 'Cart{productId: $productId, cartId: $cartId, quantity: $quantity, color: $color, size: $size}';
  }
}