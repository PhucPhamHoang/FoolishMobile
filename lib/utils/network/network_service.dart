import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:fashionstore/data/dto/api_response.dart';
import 'package:flutter/cupertino.dart';

class NetworkService {
  static String domain = 'https://192.168.1.10:8080';

  const NetworkService._();

  static String sessionId = '';
  static Map<String, String> headers = {'Content-Type': 'application/json'};

  static CookieJar cookieJar = CookieJar();
  static Dio dio = Dio();

  static Future<ApiResponse> getDataFromGetRequest(String url) async {
    dio.interceptors.add(CookieManager(cookieJar));

    try {
      final Response response = await dio.get(domain + url);
      debugPrint(domain + url);

      if (response.statusCode == 200) {
        if (url.contains('/logout')) {
          cookieJar.deleteAll();
        }

        debugPrint('header: ${response.headers}');
        debugPrint('statusCode: ${response.statusCode}');
        debugPrint('data: ${response.data}');
        debugPrint('\n');
        debugPrint(
            '\n---------------------------------END-------------------------------------\n');
        debugPrint('\n');
        Map<String, dynamic> jsonMap = response.data;
        final ApiResponse responseModel = ApiResponse.fromJson(jsonMap);
        return responseModel;
      } else {
        debugPrint('header: ${response.headers}');
        debugPrint('statusCode: ${response.statusCode}');
        debugPrint('data: ${response.data}');
        debugPrint('\n');
        debugPrint(
            '\n---------------------------------END-------------------------------------\n');
        debugPrint('\n');
        throw Exception('Failed to fetch data');
      }
    } catch (e, stackTrace) {
      debugPrint('Caught exception: $e\n$stackTrace');
      throw Exception(e);
    }
  }

  static Future<ApiResponse> getDataFromPostRequest(String url,
      {Map<String, dynamic>? param, FormData? formDataParam}) async {
    dio.interceptors.add(CookieManager(cookieJar));

    try {
      final Response response = await dio.post(
        domain + url,
        data: formDataParam ?? param,
      );
      debugPrint('$domain$url | ${json.encode(param)}');

      if (response.statusCode == 200) {
        // if (url.contains('/login')) {
        //   List<Cookie> cookies = [];
        //   cookies.add(
        //     Cookie.fromSetCookieValue(
        //       response.headers.map['set-cookie']?[0] ?? '',
        //     ),
        //   );
        //   cookieJar.saveFromResponse(
        //     Uri.parse('http://localhost:8080/login'),
        //     cookies,
        //   );
        // }

        debugPrint('header: ${response.headers}');
        debugPrint('statusCode: ${response.statusCode}');
        debugPrint('data: ${response.data}');
        debugPrint('\n');
        debugPrint(
            '\n---------------------------------END-------------------------------------\n');
        debugPrint('\n');
        Map<String, dynamic> jsonMap = response.data;
        final ApiResponse responseModel = ApiResponse.fromJson(jsonMap);
        return responseModel;
      } else {
        debugPrint('header: ${response.headers}');
        debugPrint('statusCode: ${response.statusCode}');
        debugPrint('data: ${response.data}');
        debugPrint('\n');
        debugPrint(
            '\n---------------------------------END-------------------------------------\n');
        debugPrint('\n');
        throw Exception('Failed to fetch data');
      }
    } catch (e, stackTrace) {
      debugPrint('Caught exception: $e\n$stackTrace');
      throw Exception(e);
    }
  }
}
