import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fashionstore/data/enum/google_drive_folder_name_enum.dart';
import 'package:fashionstore/utils/render/value_render.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';

import '../data/dto/api_response.dart';
import '../utils/network/network_service.dart';

class GoogleDriveRepository {
  String type = 'googleDrive';

  Future<dynamic> sendPostAndGetMessage(String url, FormData paramBody,
      {bool isAuthen = false}) async {
    String message = '';

    try {
      ApiResponse response = await NetworkService.getDataFromApi(
          ValueRender.getUrl(
            type: type,
            url: url,
            isAuthen: isAuthen,
          ),
          formDataParam: paramBody);

      message = response.content;
    } catch (e, stackTrace) {
      debugPrint('Caught exception: $e\n$stackTrace');
    }

    return message;
  }

  Future<dynamic> uploadFileToGoogleDrive(File file,
      {bool isCustomer = false, bool isDelivery = false}) async {
    MultipartFile multipartFile = await MultipartFile.fromFile(file.path,
        contentType: MediaType('image', 'jpg'));

    return sendPostAndGetMessage(
      '/upLoadCustomerAvatar',
      buildBody(
          multipartFile,
          isCustomer == true
              ? GoogleDriveFolderNameEnum.CustomerAvatar.name
              : 'Root'),
      isAuthen: true,
    );
  }

  FormData buildBody(MultipartFile file, String filePath) {
    FormData formData = FormData();

    formData.fields.addAll([
      const MapEntry('shared', 'true'),
      MapEntry('filePath', filePath),
    ]);

    formData.files.addAll([MapEntry('fileUpload', file)]);

    return formData;
  }
}
