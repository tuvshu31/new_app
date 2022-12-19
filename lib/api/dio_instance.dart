import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';

enum Method { get, post, put, delete }

class DioClient {
  Dio dio = Dio(BaseOptions(
      // baseUrl: "http://192.168.32.1:8000/",
      baseUrl: 'http://3.35.52.56:8000/',
      connectTimeout: 50000,
      receiveTimeout: 30000));

  String _getMethodName(Method method) {
    switch (method) {
      case Method.delete:
        return 'DELETE';
      case Method.put:
        return 'PUT';
      case Method.get:
        return 'GET';
      case Method.post:
        return 'POST';
    }
  }

  Future<dynamic> sendRequest(
    String path,
    Method _method,
    dynamic body,
    Map<String, dynamic>? queryParam,
  ) async {
    try {
      Response<String> response = await dio.request(
        path,
        data: body,
        options: Options(method: _getMethodName(_method)),
        queryParameters: queryParam,
      );

      dynamic responseJson = json.decode(response.data!);
      return responseJson;
    } catch (e) {
      if (e is DioError) {
        log(e.toString());
      }
    }
  }

  Future<dynamic> sendFile(
    String path,
    Method _method,
    File imageFile,
  ) async {
    try {
      var formData = FormData.fromMap({
        'file':
            await MultipartFile.fromFile(imageFile.path, filename: 'image.png')
      });
      Response<String> _response = await dio.request(
        path,
        data: formData,
        options: Options(method: _getMethodName(_method)),
      );
      dynamic _responseJson = json.decode(_response.data!);

      if (_responseJson['success'] == true) {
        return _responseJson;
      } else {
        print(_responseJson);
      }
    } catch (e) {
      if (e is DioError) {
        print(e);
      }
    }
  }
}
