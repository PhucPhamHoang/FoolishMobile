import 'package:fashionstore/data/dto/ResponseDto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkService {
  static String domain = 'http://192.168.1.9:8080';

  const NetworkService._();

  static Future<ResponseDto> getData(String url) async {
    print(domain + url);

    try{
      final response = await http.get(Uri.parse(domain + url));

      if (response.statusCode == 200) {
        print(response.body);
        Map<String, dynamic> jsonMap = json.decode(response.body);
        final ResponseDto responseModel = ResponseDto.fromJson(jsonMap);
        return responseModel;
      }
      else {
        throw Exception('Failed to fetch data');
      }
    }
    catch(e) {
      throw Exception(e);
    }
  }
}