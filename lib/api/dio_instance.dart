import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

const localUrl = "http://192.168.1.191:8000/e24/";
const prodUrl = 'https://www.e24api1215.com/e24/';

class DioClient {
  Dio dio = Dio(
    BaseOptions(
      // baseUrl: localUrl,
      baseUrl: prodUrl,
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
    Method method,
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
          method: _getMethodName(method),
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
    List images,
  ) async {
    try {
      List<MultipartFile> small = [];
      List<MultipartFile> large = [];
      for (var i = 0; i < images.length; i++) {
        String imagePath = images[i];
        ImageProperties properties =
            await FlutterNativeImage.getImageProperties(imagePath);
        File compressedLargeImage = await FlutterNativeImage.compressImage(
            imagePath,
            quality: 90,
            targetWidth: 600,
            targetHeight:
                (properties.height! * 600 / properties.width!.toInt()).round());
        MultipartFile largeImage =
            await MultipartFile.fromFile(compressedLargeImage.path);
        large.add(largeImage);
        File compressedSmallImage = await FlutterNativeImage.compressImage(
            imagePath,
            quality: 90,
            targetWidth: 300,
            targetHeight:
                (properties.height! * 300 / properties.width!.toInt()).round());
        MultipartFile smallImage =
            await MultipartFile.fromFile(compressedSmallImage.path);
        small.add(smallImage);
      }
      FormData formData = FormData.fromMap(
        {'small': small, 'large': large},
      );
      Response<String> response = await dio.request(
        path,
        data: formData,
        options: Options(method: _getMethodName(method)),
      );
      dynamic responseJson = json.decode(response.data!);

      if (responseJson['success'] == true) {
        return responseJson;
      } else {
        log(responseJson);
      }
    } catch (e) {
      if (e is DioError) {
        log(e.toString());
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
