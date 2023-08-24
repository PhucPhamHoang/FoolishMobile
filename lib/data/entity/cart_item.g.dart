// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
      json['id'] as int,
      json['customerId'] as int,
      json['productManagementId'] as int,
      json['productId'] as int,
      json['quantity'] as int,
      json['buyingStatus'] as String,
      json['selectStatus'] as int,
      json['color'] as String,
      json['size'] as String,
      json['name'] as String,
      json['brand'] as String,
      json['image1'] as String,
      (json['sellingPrice'] as num).toDouble(),
      (json['discount'] as num).toDouble(),
    );

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'productManagementId': instance.productManagementId,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'selectStatus': instance.selectStatus,
      'buyingStatus': instance.buyingStatus,
      'color': instance.color,
      'size': instance.size,
      'name': instance.name,
      'brand': instance.brand,
      'image1': instance.image1,
      'sellingPrice': instance.sellingPrice,
      'discount': instance.discount,
    };
