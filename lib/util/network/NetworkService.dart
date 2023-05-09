import 'package:fashionstore/data/dto/ResponseDto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

class NetworkService {
  static String domain = 'http://192.168.1.4:8080';

  const NetworkService._();

  static Future<ResponseDto> getDataFromGetRequest(String url) async {
    try{
      final Response response = await http.get(Uri.parse(domain + url));
      print(domain + url);

      if (response.statusCode == 200) {
        print(response.body);
        print('\n');
        print('\n---------------------------------END-------------------------------------\n');
        print('\n');
        Map<String, dynamic> jsonMap = json.decode(response.body);
        final ResponseDto responseModel = ResponseDto.fromJson(jsonMap);
        return responseModel;
      }
      else {
        print(response.body);
        print('\n');
        print('\n---------------------------------END-------------------------------------\n');
        print('\n');
        throw Exception('Failed to fetch data');
      }
    }
    catch(e) {
      throw Exception(e);
    }
  }


  static Future<ResponseDto> getDataFromPostRequest(String url, Map<String, dynamic> param) async {
    try{
      final Response response = await http.post(
        Uri.parse(domain + url),
        body: json.encode(param),
        headers: {'Content-Type': 'application/json'},
      );
      print('$domain$url | ${json.encode(param)}');

      if (response.statusCode == 200) {
        print(response.body);
        print('\n');
        print('\n---------------------------------END-------------------------------------\n');
        print('\n');
        Map<String, dynamic> jsonMap = json.decode(response.body);
        final ResponseDto responseModel = ResponseDto.fromJson(jsonMap);
        return responseModel;
      }
      else {
        print(response.body);
        print('\n');
        print('\n---------------------------------END-------------------------------------\n');
        print('\n');
        throw Exception('Failed to fetch data');
      }
    }
    catch(e) {
      throw Exception(e);
    }
  }
}