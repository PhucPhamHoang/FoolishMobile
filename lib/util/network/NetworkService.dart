import 'package:fashionstore/data/dto/ResponseDto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkService {
  String domain = 'http://localhost:8080';

  Future<void> getData(String url) async {
    final response = await http.get(Uri.parse(domain + url));

    if (response.statusCode == 200) {
      final ResponseDto responseModel = json.decode(response.body);
      print(responseModel);
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}