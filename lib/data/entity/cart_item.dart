import 'package:json_annotation/json_annotation.dart';

part 'cart_item.g.dart';

@JsonSerializable()
class CartItem {
  @JsonKey(name: 'id')
  int id;
  int customerId;
  int productManagementId;
  int productId;
  int quantity;
  int selectStatus;
  String buyingStatus;
  String color;
  String size;
  String name;
  String brand;
  String image1;
  double sellingPrice;
  double discount;

  CartItem(
      this.id,
      this.customerId,
      this.productManagementId,
      this.productId,
      this.quantity,
      this.buyingStatus,
      this.selectStatus,
      this.color,
      this.size,
      this.name,
      this.brand,
      this.image1,
      this.sellingPrice,
      this.discount);

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  factory CartItem.clone(CartItem source) {
    return CartItem(
        source.id,
        source.customerId,
        source.productManagementId,
        source.productId,
        source.quantity,
        source.buyingStatus,
        source.selectStatus,
        source.color,
        source.size,
        source.name,
        source.brand,
        source.image1,
        source.sellingPrice,
        source.discount);
  }

  @override
  String toString() {
    return 'CartItem{id: $id, customerId: $customerId, productManagementId: $productManagementId, productId: $productId, quantity: $quantity, selectedStatus: $selectStatus, buyingStatus: $buyingStatus, color: $color, size: $size, name: $name, brand: $brand, image1: $image1, sellingPrice: $sellingPrice, discount: $discount}';
  }

  bool isSelected() {
    if (selectStatus == 0) {
      return false;
    } else {
      return true;
    }
  }

  static List<CartItem> getSelectedCartItemList(
      List<CartItem> allCartItemList) {
    List<CartItem> result = [];

    for (int i = 0; i < allCartItemList.length; i++) {
      if (allCartItemList[i].selectStatus == 1) {
        result.add(allCartItemList[i]);
      }
    }

    return result;
  }
}
