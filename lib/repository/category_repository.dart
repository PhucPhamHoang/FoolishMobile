import 'dart:convert';

import 'package:fashionstore/data/dto/api_response.dart';
import 'package:fashionstore/data/entity/category.dart';
import 'package:fashionstore/utils/network/network_service.dart';
import 'package:fashionstore/utils/render/value_render.dart';
import 'package:flutter/cupertino.dart';

class CategoryRepository {
  String type = 'category';

  Future<dynamic> getList(String url, {bool isAuthen = false}) async {
    try {
      ApiResponse response =
          await NetworkService.getDataFromApi(ValueRender.getUrl(
        type: type,
        url: url,
        isAuthen: isAuthen,
      ));

      if (json.decode(jsonEncode(response.result)) == 'success') {
        List<dynamic> jsonList = json.decode(jsonEncode(response.content));

        return jsonList.map((json) => Category.fromJson(json)).toList();
      } else {
        Map<String, dynamic> jsonMap =
            json.decode(jsonEncode(response.content));

        return jsonMap.toString();
      }
    } catch (e, stackTrace) {
      debugPrint('Caught exception: $e\n$stackTrace');
    }

    return [];
  }

  Future<dynamic> getAllCategories() async {
    return getList('/allCategories');
  }
}
