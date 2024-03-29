import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:fashionstore/data/dto/api_response.dart';
import 'package:fashionstore/data/enum/local_storage_key_enum.dart';
import 'package:fashionstore/utils/local_storage/local_storage_service.dart';
import 'package:flutter/cupertino.dart';

class NetworkService {
  static String domain = 'https://192.168.1.10:8080';

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
      if (url.contains('/authen')) {
        String jwtFromStorage = await LocalStorageService.getLocalStorageData(
            LocalStorageKeyEnum.SAVED_JWT.name) as String;

        dio.options.headers['Authorization'] = 'Bearer $jwtFromStorage';
      }

      final Response response = (param == null && formDataParam == null)
          ? await dio.get(domain + url)
          : await dio.post(
              domain + url,
              data: formDataParam ?? param,
            );

      debugPrint(domain + url);

      if (url.contains('/logout')) {
        LocalStorageService.removeLocalStorageData(
          LocalStorageKeyEnum.SAVED_JWT.name,
        );
        cookieJar.deleteAll();
      }

      debugPrint('header: ${response.headers}');
      debugPrint('statusCode: ${response.statusCode}');
      debugPrint('request: ${param ?? formDataParam.toString() ?? 'null'}');
      debugPrint('response: ${response.data}');
      debugPrint('\n');
      debugPrint(
          '\n---------------------------------END-------------------------------------\n');
      debugPrint('\n');

      Map<String, dynamic> jsonMap = response.data;
      final ApiResponse responseModel = ApiResponse.fromJson(jsonMap);

      return responseModel;
    } catch (e, stackTrace) {
      debugPrint(domain + url);
      debugPrint('Caught exception: $e\n$stackTrace');
      throw Exception(e);
    }
  }
}
