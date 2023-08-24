import 'dart:convert';

import 'package:fashionstore/utils/render/value_render.dart';
import 'package:flutter/cupertino.dart';

import '../data/dto/api_response.dart';
import '../data/entity/translator_language.dart';
import '../utils/network/network_service.dart';

class TranslatorRepository {
  String type = 'translator';

  Future<dynamic> getList(String url, {bool isAuthen = false}) async {
    try {
      ApiResponse response = await NetworkService.getDataFromGetRequest(
          ValueRender.getUrl(type: type, url: url, isAuthen: isAuthen));

      if (json.decode(jsonEncode(response.result)) == 'success') {
        List<dynamic> jsonList = json.decode(jsonEncode(response.content));
        return jsonList
            .map((json) => TranslatorLanguage.fromJson(json))
            .toList();
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

  Future<dynamic> sendPostAndGetMessage(
      String url, Map<String, dynamic> paramBody,
      {bool isAuthen = false}) async {
    String message = '';

    try {
      ApiResponse response = await NetworkService.getDataFromPostRequest(
          ValueRender.getUrl(type: type, url: url, isAuthen: isAuthen),
          param: paramBody);

      message = response.content;
    } catch (e, stackTrace) {
      debugPrint('Caught exception: $e\n$stackTrace');
      message = e.toString();
    }

    return message;
  }

  Future<dynamic> translate(String text, String sourceLanguageCode) {
    return sendPostAndGetMessage(
        '/translate', {'text': text, 'sourceLanguageCode': sourceLanguageCode});
  }

  Future<dynamic> getAllLanguageList() {
    return getList('/getAllLanguageList');
  }
}
