// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemInfo _$CartItemInfoFromJson(Map<String, dynamic> json) => CartItemInfo(
      json['productId'] as int,
      json['cartId'] as int,
      json['quantity'] as int,
      json['color'] as String,
      json['size'] as String,
      json['selectStatus'] as int,
    );

Map<String, dynamic> _$CartItemInfoToJson(CartItemInfo instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'cartId': instance.cartId,
      'quantity': instance.quantity,
      'color': instance.color,
      'size': instance.size,
      'selectStatus': instance.selectStatus,
    };
