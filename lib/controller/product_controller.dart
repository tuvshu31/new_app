import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/widgets/snackbar.dart';

class ProductController extends GetxController {
  var page = 1.obs;
  var data = [].obs;
  var saved = [].obs;
  var store = [].obs;
  var list = [].obs;
  var total = 0.obs;
  var search = 0.obs;
  var searchText = "".obs;
  var storeId = 0.obs;
  var typeId = 1.obs;
  var orders = [].obs;
  var categoryId = 0.obs;
  var hasMore = true.obs;
  var onScrollShowHide = false.obs;
  var fetchingData = false.obs;
  RxInt chosenId = 0.obs;

  //Хэрэглэгч бүртгэл үүсгэх
  void registerLogin(dynamic body, context) async {
    dynamic response = await RestApi().registerUser(body);
    dynamic data = Map<String, dynamic>.from(response);
    if (data["success"]) {
      successSnackBar("Амжилттай бүртгэгдлээ", 2, context);
    } else {
      errorSnackBar("Алдаа гарлаа, дахин оролдоно уу", 2, context);
    }
  }

  //Бараануудыг шүүж дуудах
  void callProducts() async {
    var _query = {
      "typeId": typeId.value,
      "page": page.value,
      "categoryId": categoryId.value,
      "store": storeId.value,
      "search": search.value != 0 ? searchText.value : 0
    };
    _query.removeWhere((key, value) => value == 0);
    print(_query);

    dynamic products = await RestApi().getProducts(_query);
    dynamic p = Map<String, dynamic>.from(products);
    total.value = p["pagination"]["count"];
    if (p["data"].length < p["pagination"]["limit"]) {
      hasMore.value = false;
    }
    data = data + p['data'];
    var _userId = RestApiHelper.getUserId();
    if (_userId != 0) {
      dynamic response =
          await RestApi().getUserProducts(_userId, {"page": page.value});
      dynamic d = Map<String, dynamic>.from(response);
      list.value = d["list"];
    }
  }

  void changeTab(int index) {
    data.clear();
    page.value = 1;
    hasMore.value = true;
    categoryId.value = index;
    callProducts();
  }

  void getOrders() async {
    int _userId = RestApiHelper.getUserId();
    orders.clear();
    if (_userId == 1) {
      dynamic response = await RestApi().getOrdersForAdmin();
      dynamic d = Map<String, dynamic>.from(response);
      orders.value = d["data"];
    } else {
      dynamic response = await RestApi().getOrders({"userId": _userId});
      dynamic d = Map<String, dynamic>.from(response);
      orders.value = d["data"];
    }
  }
}
