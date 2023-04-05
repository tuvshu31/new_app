import 'dart:developer';
import 'dart:convert';
import 'package:dio/dio.dart';

class DioMessage {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.messagepro.mn/',
      connectTimeout: Duration(minutes: 2),
      receiveTimeout: Duration(minutes: 1),
    ),
  );

  Future<dynamic> sendMessage(
    String path,
    String phone,
    String text,
  ) async {
    try {
      Response<String> response = await dio.request(
        path,
        data: {},
        options: Options(method: "GET"),
        queryParameters: {
          "key": "ebd1733ca0be0cbdc0f43053adfd7ca4",
          "from": "72222700",
          "to": phone,
          "text": text,
        },
      );
      dynamic responseJson = json.decode(response.data!);
      return responseJson;
    } catch (e) {
      if (e is DioError) {
        log(e.toString());
      }
    }
  }
}
