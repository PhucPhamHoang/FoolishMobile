import 'dart:convert';

import 'package:fashionstore/utils/render/value_render.dart';
import 'package:flutter/cupertino.dart';

import '../data/dto/api_response.dart';
import '../data/entity/cart_item.dart';
import '../data/entity/cart_item_info.dart';
import '../utils/network/network_service.dart';

class CartRepository {
  String type = 'cart';

  Future<dynamic> sendPostAndGetList(String url, Map<String, dynamic> paramBody,
      {bool isAuthen = false}) async {
    try {
      ApiResponse response = await NetworkService.getDataFromPostRequest(
          ValueRender.getUrl(
            type: type,
            url: url,
            isAuthen: isAuthen,
          ),
          param: paramBody);

      if (json.decode(jsonEncode(response.result)) == 'success') {
        List<dynamic> jsonList = json.decode(jsonEncode(response.content));
        return jsonList.map((json) => CartItem.fromJson(json)).toList();
      } else {
        Map<String, dynamic> jsonMap =
            json.decode(jsonEncode(response.content));
        return jsonMap.toString();
      }
    } catch (e, stackTrace) {
      debugPrint('Caught exception: $e\n$stackTrace');
    }
  }

  Future<dynamic> sendPostAndGetMessage(
      String url, Map<String, dynamic> paramBody,
      {bool isAuthen = false}) async {
    String message = '';

    try {
      ApiResponse response = await NetworkService.getDataFromPostRequest(
          ValueRender.getUrl(type: type, url: url, isAuthen: true),
          param: paramBody);

      message = response.content;
    } catch (e, stackTrace) {
      debugPrint('Caught exception: $e\n$stackTrace');
    }

    return message;
  }

  Future<dynamic> getMessage(String url, {bool isAuthen = false}) async {
    String message = '';

    try {
      ApiResponse response =
          await NetworkService.getDataFromGetRequest(ValueRender.getUrl(
        type: type,
        url: url,
        isAuthen: isAuthen,
      ));

      message = response.content.toString();
    } catch (e, stackTrace) {
      debugPrint('Caught exception: $e\n$stackTrace');
    }

    return message;
  }

  Future<dynamic> getTotalCartItemQuantity() {
    return getMessage(
      '/totalCartItemQuantity',
      isAuthen: true,
    );
  }

  Future<dynamic> showFullCart(int page, int limit) {
    return sendPostAndGetList('/showFullCart', isAuthen: true, {
      'page': page,
      'limit': limit,
    });
  }

  Future<dynamic> update(List<CartItemInfo> cartItemList) {
    return sendPostAndGetMessage(
        '/update', isAuthen: true, {"objectList": cartItemList});
  }

  Future<dynamic> add(int productId, String color, String size, int quantity) {
    return sendPostAndGetMessage('/add', isAuthen: true, {
      'productId': productId,
      'color': color,
      'size': size,
      'quantity': quantity,
    });
  }

  Future<dynamic> remove(List<int> cartIdList) {
    return sendPostAndGetMessage(
        '/remove', isAuthen: true, {"integerArray": cartIdList});
  }

  Future<dynamic> filterCartItems(String? name, List<String>? status,
      String? brand, int? page, int? limit) {
    return sendPostAndGetList('/filterCartItems', isAuthen: true, {
      "filter": {
        "name": name,
        "status": status,
        "brand": brand,
      },
      "pagination": {
        "page": page,
        "limit": limit,
      }
    });
  }
}
