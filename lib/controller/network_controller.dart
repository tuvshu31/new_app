import 'dart:io';
import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:Erdenet24/widgets/text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnectivity {
  NetworkConnectivity._();
  static final _instance = NetworkConnectivity._();
  static NetworkConnectivity get instance => _instance;
  final _networkConnectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;
  // 1.
  void initialise() async {
    ConnectivityResult result = await _networkConnectivity.checkConnectivity();
    _checkStatus(result);
    _networkConnectivity.onConnectivityChanged.listen((result) {
      log(result.toString());
      _checkStatus(result);
    });
  }

// 2.
  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}

class NetWorkController extends GetxController {
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';
  RxBool hasNetwork = true.obs;
  void checkNetworkAccess(context) {
    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen(
      (source) {
        _source = source;
        // 1.
        switch (_source.keys.toList()[0]) {
          case ConnectivityResult.mobile:
            string = _source.values.toList()[0]
                ? 'Mobile: Online'
                : 'Mobile: Offline';
            break;
          case ConnectivityResult.wifi:
            string =
                _source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
            break;
          case ConnectivityResult.none:
          default:
            string = 'Offline';
        }
        if (_source.keys.toList()[0] == ConnectivityResult.none) {
          string = "Интернэт холболтоо шалгана уу!";
          hasNetwork.value = false;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                string,
                style: const TextStyle(
                  fontFamily: "Nunito",
                ),
              ),
            ),
          );
        } else {
          hasNetwork.value = true;
        }
      },
    );
  }

  void showNetworkSnackbar(context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomText(text: string),
      ),
    );
  }
}
