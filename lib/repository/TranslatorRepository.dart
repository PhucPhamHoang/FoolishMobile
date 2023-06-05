import 'dart:convert';

import '../data/dto/ResponseDto.dart';
import '../data/entity/TranslatorLanguage.dart';
import '../util/network/NetworkService.dart';

class TranslatorRepository {
  String baseUrl = '/translator';

  Future<dynamic> getList(String url) async {
    try{
      ResponseDto response = await NetworkService.getDataFromGetRequest('$baseUrl$url');

      if(json.decode(jsonEncode(response.result)) == 'success') {
        List<dynamic> jsonList = json.decode(jsonEncode(response.content));
        return jsonList.map((json) => TranslatorLanguage.fromJson(json)).toList();
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

  Future<dynamic> sendPostAndGetMessage(String url, Map<String, dynamic> paramBody) async {
    String message = '';

    try{
      ResponseDto response = await NetworkService.getDataFromPostRequest(
          '$baseUrl$url',
          param: paramBody
      );

      message = response.content;
    }
    catch(e, stackTrace) {
      print('Caught exception: $e\n$stackTrace');
      message = e.toString();
    }

    return message;
  }


  Future<dynamic> translate(String text, String sourceLanguageCode) {
    return sendPostAndGetMessage(
      '/translate',
      {
        'text': text,
        'sourceLanguageCode': sourceLanguageCode
      }
    );
  }

  Future<dynamic> getAllLanguageList() {
    return getList('/getAllLanguageList');
  }
}