import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:fashionstore/data/dto/api_response.dart';
import 'package:fashionstore/data/enum/local_storage_key_enum.dart';
import 'package:fashionstore/utils/local_storage/local_storage_service.dart';
import 'package:flutter/cupertino.dart';

class NetworkService {
  static String domain = 'https://192.168.1.22:8080';

  const NetworkService._();

  static String sessionId = '';
  static Map<String, String> headers = {'Content-Type': 'application/json'};

  static CookieJar cookieJar = CookieJar();
  static Dio dio = Dio();

  static Future<ApiResponse> getDataFromApi(
    String url, {
    Map<String, dynamic>? param,
    FormData? formDataParam,
  }) async {
    dio.interceptors.add(CookieManager(cookieJar));

    try {
      final Response response = (param == null && formDataParam == null)
          ? await dio.get(domain + url)
          : await dio.post(
              domain + url,
              data: formDataParam ?? param,
            );

      debugPrint(domain + url);

      if (response.statusCode == 200) {
        if (url.contains('/logout')) {
          LocalStorageService.removeLocalStorageData(
            LocalStorageKeyEnum.SAVED_JWT.name,
          );
          cookieJar.deleteAll();
        }

        if (url.contains('/authen')) {
          dio.options.headers['Authorization'] =
              'Bearer ${LocalStorageService.getLocalStorageData(LocalStorageKeyEnum.SAVED_JWT.name)}';
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
      debugPrint(domain + url);
      debugPrint('Caught exception: $e\n$stackTrace');
      throw Exception(e);
    }
  }
}
