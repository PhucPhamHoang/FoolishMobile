import 'dart:convert';

import '../data/dto/ResponseDto.dart';
import '../data/entity/Product.dart';
import '../util/network/NetworkService.dart';

class ShopRepository {
  String baseUrl = '/shop';

  Future<List<Product>> getAllProducts() async {
    try{
      ResponseDto response = await NetworkService.getDataFromGetRequest('$baseUrl/allProoducts');

      List<dynamic> jsonList = json.decode(jsonEncode(response.content));

      return jsonList.map((json) => Product.fromJson(json)).toList();
    }
    catch(e, stackTrace) {
      print('Caught exception: $e\n$stackTrace');
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