import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fashionstore/data/enum/GoogleDriveFolderNameEnum.dart';
import 'package:http_parser/http_parser.dart';

import '../data/dto/ResponseDto.dart';
import '../util/network/NetworkService.dart';

class GoogleDriveRepository {
  String baseUrl = '/googleDrive';

  Future<dynamic> sendPostAndGetMessage(String url, FormData paramBody) async {
    String message = '';

    try {
      ResponseDto response = await NetworkService.getDataFromPostRequest(
          '$baseUrl$url',
          formDataParam: paramBody
      );

      message = response.content;
    }
    catch (e, stackTrace) {
      print('Caught exception: $e\n$stackTrace');
    }

    return message;
  }

  Future<dynamic> uploadFileToGoogleDrive(File file, {bool isCustomer = false, bool isDelivery = false}) async {
    MultipartFile multipartFile = await MultipartFile.fromFile(
      file.path,
      contentType: MediaType('image', 'jpg')
    );

    return sendPostAndGetMessage(
      '/upLoadCustomerAvatar',
      buildBody(
          multipartFile,
          isCustomer == true ? GoogleDriveFolderNameEnum.CustomerAvatar.name : 'Root'
      )
    );
  }

  FormData buildBody(MultipartFile file, String filePath) {
    FormData formData = FormData();

    formData.fields.addAll([
      const MapEntry('shared', 'true'),
      MapEntry('filePath', filePath),
    ]);

    formData.files.addAll([
      MapEntry(
        'fileUpload',
        file
      )
    ]);

    return formData;
  }
}