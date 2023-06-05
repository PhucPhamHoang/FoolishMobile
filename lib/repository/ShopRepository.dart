import 'dart:convert';

import '../data/dto/ResponseDto.dart';
import '../data/entity/Product.dart';
import '../util/network/NetworkService.dart';

class ShopRepository {
  String baseUrl = '/shop';

  Future<dynamic> getList(String url) async {
    try{
      ResponseDto response = await NetworkService.getDataFromGetRequest(baseUrl + url);

      if(json.decode(jsonEncode(response.result)) == 'success') {
        List<dynamic> jsonList = json.decode(jsonEncode(response.content));
        return jsonList.map((json) => Product.fromJson(json)).toList();
      }
      else {
        Map<String, dynamic> jsonMap = json.decode(jsonEncode(response.content));
        return jsonMap.toString();
      }
    }
    catch(e, stackTrace) {
      print('Caught exception: $e\n$stackTrace');
    }

    return [];
  }

  Future<dynamic> getObject(String url) async {
    Map<String, dynamic> jsonMap;

    try{
      ResponseDto response = await NetworkService.getDataFromGetRequest(baseUrl + url);

      if(json.decode(jsonEncode(response.result)) == 'success') {
        jsonMap = json.decode(jsonEncode(response.content));
        return Product.fromJson(jsonMap);
      }
      else {
        return response.content;
      }
    }
    catch(e, stackTrace) {
      print('Caught exception: $e\n$stackTrace');
    }
  }

  Future<dynamic> sendPostAndGetList(String url, Map<String, dynamic> paramBody) async {
    try{
      ResponseDto response = await NetworkService.getDataFromPostRequest(
          '$baseUrl$url',
          param: paramBody
      );

      if(json.decode(jsonEncode(response.result)) == 'success') {
        List<dynamic> jsonList = json.decode(jsonEncode(response.content));
        return jsonList.map((json) => Product.fromJson(json)).toList();
      }
      else {
        return response.content;
      }
    }
    catch(e, stackTrace) {
      print('Caught exception: $e\n$stackTrace');
    }

    return [];
  }


  Future<dynamic> getProductList(String type) async {
    String url = '';

    switch(type){
      case 'NEW_ARRIVAL': url = '/newArrivalProducts';break;
      case 'TOP_BEST_SELLERS': url = '/top8BestSellers';break;
      case 'HOT_DISCOUNT': url = '/hotDiscountProducts';break;
      case 'ALL': url = '/allProoducts';break;
    }

    return getList(url);
  }

  Future<dynamic> searchProduct(String productName, {int page = 1, int limit = 10}) async {
    return sendPostAndGetList(
        '/filterProducts',
        {
          'filter': {
            'name': productName
          },
          'pagination': {
            'page': page,
            'limit': limit
          }
        }
    );
  }

  Future<dynamic> getAllProducts(int page, int limit) async {
    return sendPostAndGetList(
        '/allProducts',
        {
          'page': page,
          'limit': limit
        }
    );
  }

  Future<dynamic> getFilteredProducts(int page, int limit, {String? brand, double? minPrice, double? maxPrice, List<String>? categories}) async {
    return sendPostAndGetList(
        '/filterProducts',
        {
          'filter': {
            'brand': brand,
            'maxPrice': maxPrice,
            'minPrice': minPrice,
            'categories': categories
          },
          'pagination': {
            'page': page,
            'limit': limit
          }
        }
    );
  }

  Future<dynamic> getProductDetails(int productId) {
    return getList('/product_id=$productId');
  }
}