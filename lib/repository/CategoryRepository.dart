import 'dart:convert';

import 'package:fashionstore/data/dto/ResponseDto.dart';
import 'package:fashionstore/data/entity/Category.dart';
import 'package:fashionstore/util/network/NetworkService.dart';

class CategoryRepository {
  String baseUrl = '/category';

  Future<List<Category>> getAllCategories() async {
    try{
      ResponseDto response = await NetworkService.getData('$baseUrl/allCategories');

      List<dynamic> jsonList = json.decode(jsonEncode(response.content));

      return jsonList.map((json) => Category.fromJson(json)).toList();
    }
    catch(e, stackTrace) {
      print('Caught exception: $e\n$stackTrace');
    }

    return [];
  }
}