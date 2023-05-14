import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:fashionstore/data/dto/ResponseDto.dart';
import 'dart:convert';

class NetworkService {
  static String domain = 'http://192.168.111.48:8080';

  const NetworkService._();

  static String sessionId = '';
  static Map<String, String> headers = {'Content-Type': 'application/json'};

  static CookieJar cookieJar = CookieJar();
  static Dio dio = Dio();

  static Future<ResponseDto> getDataFromGetRequest(String url) async {
    dio.interceptors.add(CookieManager(cookieJar));

    try{
      final Response response = await dio.get(
        domain + url,
      );
      print(domain + url);

      if (response.statusCode == 200) {
        print(response.headers);
        print(response.statusCode);
        print(response.data);
        print('\n');
        print('\n---------------------------------END-------------------------------------\n');
        print('\n');
        Map<String, dynamic> jsonMap = response.data;
        final ResponseDto responseModel = ResponseDto.fromJson(jsonMap);
        return responseModel;
      }
      else {
        print(response.headers);
        print(response.statusCode);
        print(response.data);
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
    dio.interceptors.add(CookieManager(cookieJar));

    try{
      final Response response = await dio.post(
        domain + url,
        data: param,
      );
      print('$domain$url | ${json.encode(param)}');

      if (response.statusCode == 200) {
        if(url.contains('/login')) {
          List<Cookie> cookies = [];
          cookies.add(Cookie.fromSetCookieValue(response.headers.map['set-cookie']![0]));
          cookieJar.saveFromResponse(Uri.parse('http://localhost:8080/login'), cookies);
        }

        print(response.headers);
        print(response.statusCode);
        print(response.data);
        print('\n');
        print('\n---------------------------------END-------------------------------------\n');
        print('\n');
        Map<String, dynamic> jsonMap = response.data;
        final ResponseDto responseModel = ResponseDto.fromJson(jsonMap);
        return responseModel;
      }
      else {
        print(response.headers);
        print(response.statusCode);
        print(response.data);
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