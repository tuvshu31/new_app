import 'dart:convert';
import 'package:get/get.dart';
import 'package:Erdenet24/api/local_notification.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';

const _baseUrl = "baseUrl";

enum Environment { dev, prod }

Map<String, dynamic> _config = {};

void setEnvironment(Environment env) {
  switch (env) {
    case Environment.dev:
      _config = devConstants;
      break;

    case Environment.prod:
      _config = prodConstants;
      break;
  }
}

dynamic get apiBaseUrl {
  return _config[_baseUrl];
}

Map<String, dynamic> devConstants = {
  _baseUrl: "http://192.168.1.191:8000",
};

Map<String, dynamic> prodConstants = {
  _baseUrl: "https://www.e24api1215.com",
};
