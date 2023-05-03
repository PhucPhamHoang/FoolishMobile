import 'dart:convert';

import 'package:fashionstore/data/dto/ResponseDto.dart';
import 'package:fashionstore/data/entity/Category.dart';
import 'package:fashionstore/util/network/NetworkService.dart';

class CategoryRepository {
  String baseUrl = '/category';

  Future<dynamic> getList(String url) async {
    try{
      ResponseDto response = await NetworkService.getDataFromGetRequest(baseUrl + url);

      if(json.decode(jsonEncode(response.result)) == 'success') {
        List<dynamic> jsonList = json.decode(jsonEncode(response.content));
        return jsonList.map((json) => Category.fromJson(json)).toList();
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


  Future<dynamic> getAllCategories() async {
    return getList('/allCategories');
  }
}