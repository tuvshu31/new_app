import 'dart:async';
import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Erdenet24/widgets/snackbar.dart';

class CartController extends GetxController {
  var cartList = [].obs;
  var storeList = [].obs;
  var savedList = [].obs;
  var closedStoreList = [].obs;
  RxInt cartItemCount = 0.obs;

  void addProduct(product, context) {
    cartItemCount++;
    var i = cartList.indexWhere((e) => e["id"] == product["id"]);
    if (i > -1) {
      cartList[i]["quantity"] += 1;
    } else {
      cartList.add({...product, "quantity": 1});
    }
    cartList.refresh();
  }

  void getUserProducts() async {
    dynamic response =
        await RestApi().getUserProducts(RestApiHelper.getUserId(), {"page": 1});
    dynamic d = Map<String, dynamic>.from(response);
    savedList.value = d["savedProductsIdList"];
    closedStoreList.value = d["closedStoreList"];
    print(d);
  }

  void saveProduct(product, context) async {
    CustomDialogs().showLoadingDialog();
    var body = {
      "userId": RestApiHelper.getUserId(),
      "productId": product["id"]
    };
    if (savedList.contains(product["id"])) {
      dynamic response = await RestApi().deleteUserProduct(body);
      dynamic res = Map<String, dynamic>.from(response);
      Get.back();
      if (res["success"]) {
        savedList.remove(product["id"]);
      } else {
        customSnackbar(DialogType.error, "Алдаа гарлаа", 2);
      }
    } else {
      dynamic response = await RestApi().saveUserProduct(body);
      dynamic res = Map<String, dynamic>.from(response);
      Get.back();
      if (res["success"]) {
        savedList.add(product["id"]);
        customSnackbar(DialogType.success, "Амжилттай хадгалагдлаа", 2);
      } else {
        customSnackbar(DialogType.error, "Алдаа гарлаа", 2);
      }
    }
  }

  void removeProduct(product, context) {
    var i = cartList.indexWhere((e) => e["id"] == product["id"]);
    cartItemCount = cartItemCount - cartList[i]["quantity"];
    cartList.removeAt(i);

    var n = storeList.indexWhere((e) => e == product["store"]);
    if (n > -1) {
      storeList.remove(product["store"]);
    }
    cartList.refresh();
  }

  void increaseQuantity(product, context) {
    var i = cartList.indexWhere((e) => e["id"] == product["id"]);
    cartList[i]["quantity"] += 1;
    cartItemCount++;
    cartList.refresh();
  }

  void decreaseQuantity(product) {
    var i = cartList.indexWhere((e) => e["id"] == product["id"]);
    if (cartList[i]["quantity"] > 1) {
      cartList[i]["quantity"] -= 1;
      cartItemCount--;
    }
    cartList.refresh();
  }

  String generateOrderId() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyMMddkkmmss').format(now);
    return formattedDate;
  }

  get deliveryCost => 3000;
  get stores => storeList;
  get saved => savedList;
  get products => cartList;
  get productSubtotal =>
      cartList.map((e) => double.parse(e["price"]) * e["quantity"]).toList();
  // _products.entries
  //     .map((e) => double.parse(e.key['price']) * e.value)
  //     .toList();
  get subTotal => cartList.isNotEmpty
      ? cartList
          .map((e) => double.parse(e['price']) * e["quantity"])
          .toList()
          .reduce((value, element) => value + element)
      : 0;
  get total => subTotal + deliveryCost;
  get length => cartList.isNotEmpty ? cartList.length : 0;
}
