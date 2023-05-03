import 'dart:convert';

import '../data/dto/ResponseDto.dart';
import '../data/entity/User.dart';
import '../util/network/NetworkService.dart';

class AuthenticationRepository {
  String baseUrl = '/systemAuthentication';

  Future<String> sendPostAndGetMessage(String url, Map<String, dynamic> paramBody) async {
    String message = '';
    try{
      ResponseDto response = await NetworkService.getDataFromPostRequest(
          '$baseUrl$url',
          paramBody
      );

      message = response.content;
    }
    catch(e, stackTrace) {
      print('Caught exception: $e\n$stackTrace');
      message = e.toString();
    }

    return message;
  }

  Future<dynamic> sendPostAndGetObject(String url, Map<String, dynamic> paramBody) async {
    Map<String, dynamic> jsonMap;
    try{
      ResponseDto response = await NetworkService.getDataFromPostRequest(
          '$baseUrl$url',
          paramBody
      );

      if(json.decode(jsonEncode(response.result)) == 'success') {
        jsonMap = json.decode(jsonEncode(response.content));
        return User.fromJson(jsonMap);
      }
      else {
        return response.content;
      }

    }
    catch(e, stackTrace) {
      print('Caught exception: $e\n$stackTrace');
    }
  }

  Future<dynamic> login(String userName, String password) async {
    return sendPostAndGetObject(
        '/login',
        {
          'userName': userName,
          'password': password
        }
    );
  }

  Future<String> register(String userName, String password, String name, String email, String phoneNumber) async {
    return sendPostAndGetMessage(
        '/register',
        {
          'userName': userName,
          'password': password,
          'customer': {
            'name': name,
            'email': email,
            'phoneNumber': phoneNumber
          }
        }
    );
  }
}