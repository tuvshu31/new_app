import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class DioClient {
  Dio dio = Dio(
    BaseOptions(
      // baseUrl: "http://192.168.8.5:8000/",
      baseUrl: 'https://www.e24api1215.com/',
      connectTimeout: const Duration(minutes: 2),
      receiveTimeout: const Duration(minutes: 1),
    ),
  );

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
    bool hasInternet =
        await _isConnectedToNetwork(checkServerConnection: false);
    if (!hasInternet) {
      CustomDialogs().showNetworkErrorDialog(() {});
    }

    try {
      Response<String> response = await dio.request(
        path,
        data: body,
        options: Options(
          method: _getMethodName(_method),
          // headers: {"content-Type": 'application/x-www-form-urlencoded'},
        ),
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
    Method method,
    File imageFile,
  ) async {
    try {
      var formData = FormData.fromMap({
        'file':
            await MultipartFile.fromFile(imageFile.path, filename: 'image.png')
      });
      Response<String> response = await dio.request(
        path,
        data: formData,
        options: Options(method: _getMethodName(method)),
      );
      dynamic responseJson = json.decode(response.data!);

      if (responseJson['success'] == true) {
        return responseJson;
      } else {
        print(responseJson);
      }
    } catch (e) {
      if (e is DioError) {
        print(e);
      }
    }
  }

  Future<bool> _isConnectedToNetwork({
    String? url,
    bool checkServerConnection = false,
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return checkServerConnection
          ? await _isConnectedToServer(url ?? 'google.com')
          : true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return checkServerConnection
          ? await _isConnectedToServer(url ?? 'google.com')
          : true;
    }
    return false;
  }

  Future<bool> _isConnectedToServer(String url) async {
    try {
      final result = await InternetAddress.lookup(url);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }
}
