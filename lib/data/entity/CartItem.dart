import 'package:json_annotation/json_annotation.dart';

part 'CartItem.g.dart';

@JsonSerializable()
class CartItem {
  @JsonKey(name: 'id')
  final int id;
  final int customerId;
  final int productManagementId;
  final int productId;
  final int quantity;
  final String buyingStatus;
  final String color;
  final String size;
  final String name;
  final String brand;
  final String image1 ;
  final double sellingPrice;
  final double discount;

  CartItem(
      this.id,
      this.customerId,
      this.productManagementId,
      this.productId,
      this.quantity,
      this.buyingStatus,
      this.color,
      this.size,
      this.name,
      this.brand,
      this.image1,
      this.sellingPrice,
      this.discount);

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  @override
  String toString() {
    return 'CartItem{id: $id, customerId: $customerId, productManagementId: $productManagementId, productId: $productId, quantity: $quantity, buyingStatus: $buyingStatus, color: $color, size: $size, name: $name, brand: $brand, image1: $image1, sellingPrice: $sellingPrice, discount: $discount}';
  }
}