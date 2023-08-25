import 'dart:convert';

import 'package:fashionstore/data/enum/local_storage_key_enum.dart';
import 'package:fashionstore/data/static/api_authen_type.dart';
import 'package:fashionstore/utils/local_storage/local_storage_service.dart';
import 'package:fashionstore/utils/render/value_render.dart';
import 'package:flutter/cupertino.dart';

import '../data/dto/api_response.dart';
import '../data/entity/user.dart';
import '../utils/network/network_service.dart';

class AuthenticationRepository {
  String type = 'systemAuthentication';

  Future<String> sendPostAndGetMessage(
      String url, Map<String, dynamic> paramBody,
      {bool isAuthen = false}) async {
    String message = '';

    try {
      ApiResponse response = await NetworkService.getDataFromApi(
          ValueRender.getUrl(isAuthen: isAuthen, type: type, url: url),
          param: paramBody);

      message = response.content;
    } catch (e, stackTrace) {
      debugPrint('Caught exception: $e\n$stackTrace');
      message = e.toString();
    }

    return message;
  }

  Future<dynamic> sendPostAndGetObject(
      String url, Map<String, dynamic> paramBody,
      {bool isAuthen = false}) async {
    Map<String, dynamic> jsonMap;
    try {
      ApiResponse response = await NetworkService.getDataFromApi(
        ValueRender.getUrl(isAuthen: isAuthen, type: type, url: url),
        param: paramBody,
      );

      if (json.decode(jsonEncode(response.result)) == 'success') {
        String jwt = response.message!;
        LocalStorageService.setLocalStorageData(
          LocalStorageKeyEnum.SAVED_JWT.name,
          jwt,
        );

        jsonMap = json.decode(jsonEncode(response.content));

        return User.fromJson(jsonMap);
      } else {
        return response.content;
      }
    } catch (e, stackTrace) {
      debugPrint('Caught exception: $e\n$stackTrace');
    }
  }

  Future<String> getMessage(String url, {bool isAuthen = false}) async {
    String message = '';

    try {
      ApiResponse response = await NetworkService.getDataFromApi(
          ValueRender.getUrl(isAuthen: isAuthen, type: type, url: url));

      message = response.content.toString();
    } catch (e, stackTrace) {
      debugPrint('Caught exception: $e\n$stackTrace');
    }

    return message;
  }

  Future<dynamic> login(String userName, String password) async {
    return sendPostAndGetObject('/login', {
      'userName': userName,
      'password': password,
    });
  }

  Future<String> logout() async {
    return getMessage('${ApiAuthenType.authenApi}/logout', isAuthen: true);
  }

  Future<String> register(String userName, String password, String name,
      String email, String phoneNumber) async {
    return sendPostAndGetMessage('/register', {
      'userName': userName,
      'password': password,
      'customer': {'name': name, 'email': email, 'phoneNumber': phoneNumber}
    });
  }
}
