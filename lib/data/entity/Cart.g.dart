// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
      json['productId'] as int,
      json['cartId'] as int,
      json['quantity'] as int,
      json['color'] as String,
      json['size'] as String,
    );

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
      'productId': instance.productId,
      'cartId': instance.cartId,
      'quantity': instance.quantity,
      'color': instance.color,
      'size': instance.size,
    };
