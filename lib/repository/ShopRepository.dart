import 'dart:convert';

import '../data/dto/ResponseDto.dart';
import '../data/entity/Product.dart';
import '../util/network/NetworkService.dart';

class ShopRepository {
  String baseUrl = '/shop';

  Future<List<Product>> getProductList(String type) async {
    String url = '';

    switch(type){
      case 'NEW_ARRIVAL': url = '/newArrivalProducts';break;
      case 'TOP_BEST_SELLERS': url = '/top8BestSellers';break;
      case 'HOT_DISCOUNT': url = '/hotDiscountProducts';break;
      case 'ALL': url = '/allProoducts';break;
    }

    if(url != '') {
      try{
        ResponseDto response = await NetworkService.getDataFromGetRequest(baseUrl + url);

        List<dynamic> jsonList = json.decode(jsonEncode(response.content));

        return jsonList.map((json) => Product.fromJson(json)).toList();
      }
      catch(e, stackTrace) {
        print('Caught exception: $e\n$stackTrace');
      }
    }

    return [];
  }


  Future<List<Product>> searchProduct(String productName) async {
    try{
      ResponseDto response = await NetworkService.getDataFromPostRequest(
          '$baseUrl/filterProducts',
          {
            'filter': {
              'name': productName
            }
          }
      );

      List<dynamic> jsonList = json.decode(jsonEncode(response.content));

      return jsonList.map((json) => Product.fromJson(json)).toList();
    }
    catch(e, stackTrace) {
      print('Caught exception: $e\n$stackTrace');
    }

    return [];
  }
}