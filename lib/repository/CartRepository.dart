import 'dart:convert';

import '../data/dto/ResponseDto.dart';
import '../data/entity/Cart.dart';
import '../data/entity/CartItem.dart';
import '../util/network/NetworkService.dart';

class CartRepository {
  String baseUrl = '/cart';

  Future<dynamic> sendPostAndGetList(String url, Map<String, dynamic> paramBody) async {
    try {
      ResponseDto response = await NetworkService.getDataFromPostRequest(
          '$baseUrl$url',
          paramBody
      );

      if (json.decode(jsonEncode(response.result)) == 'success') {
        List<dynamic> jsonList = json.decode(jsonEncode(response.content));
        return jsonList.map((json) => CartItem.fromJson(json)).toList();
      }
      else {
        Map<String, dynamic> jsonMap = json.decode(
            jsonEncode(response.content));
        return jsonMap.toString();
      }
    }
    catch (e, stackTrace) {
      print('Caught exception: $e\n$stackTrace');
    }
  }

  Future<dynamic> sendPostAndGetMessage(String url, Map<String, dynamic> paramBody) async {
    String message = '';
    
    try {
      ResponseDto response = await NetworkService.getDataFromPostRequest(
          '$baseUrl$url',
          paramBody
      );

      message = response.content;
    }
    catch (e, stackTrace) {
      print('Caught exception: $e\n$stackTrace');
    }
    
    return message;
  }

  Future<dynamic> getMessage(String url) async {
    String message = '';

    try {
      ResponseDto response = await NetworkService.getDataFromGetRequest('$baseUrl$url');

      message = response.content.toString();
    }
    catch (e, stackTrace) {
      print('Caught exception: $e\n$stackTrace');
    }

    return message;
  }
  
  
  Future<dynamic> getTotalCartItemQuantity() {
    return getMessage('/totalCartItemQuantity');
  }
  
  Future<dynamic> showFullCart(int page, int limit) {
    return sendPostAndGetList(
      '/showFullCart',
      {
        'page': page,
        'limit': limit,
      }
    );
  }

  Future<dynamic> update(List<Cart> cartItemList) {
    return sendPostAndGetMessage(
        '/update',
        {
          "objectList": cartItemList
        }
    );
  }

  Future<dynamic> add(int productId, String color, String size, int quantity) {
    return sendPostAndGetMessage(
      '/add',
      {
        'productId': productId,
        'color': color,
        'size': size,
        'quantity': quantity,
      }
    );
  }

  Future<dynamic> remove(List<int> cartIdList) {
    return sendPostAndGetMessage(
      '/remove',
        {
          "integerArray": cartIdList
        }
    );
  }
}