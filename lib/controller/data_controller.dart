import 'package:Erdenet24/widgets/custom_dialogs.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/controller/cart_controller.dart';

class DataController extends GetxController {
  //Datagaa duudah heseg
  List<dynamic> allProducts = [].obs;
  RxDouble percentage = 0.00.obs;
  RxString downloadMessage = "".obs;
  RxBool error = false.obs;
  RxBool loading = false.obs;
  RxBool postError = false.obs;
  //UserInformation heseg
  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> phoneController = TextEditingController().obs;
  Rx<TextEditingController> entranceController = TextEditingController().obs;
  RxInt selectedTime = 0.obs;
  var cartProducts = Get.put(CartController()).products;

  // void generate6digit() => Get.put(CartController()).generate6digit();
  DateTime now = DateTime.now();
  var dio = Dio(BaseOptions(
    connectTimeout: 50000,
    receiveTimeout: 30000,
  ));
  void callProductsFromServer() async {
    try {
      final response = await dio.get(
        URL.data,
        onReceiveProgress: (bytes, total) {
          percentage.value = (bytes / total * 100);
          downloadMessage.value = "${percentage.floor()} %";
        },
      );
      allProducts = response.data;
    } on DioError {
      error.value = true;
    }
  }

  void postDataToTheServer(dynamic data) async {
    try {
      loading.value = true;
      await dio.post(
        URL.userInfo,
        data: data,
      );
      loading.value = false;
      // CustomDialogs.showSuccessDialog(true,
      //     "Захиалгын мэдээллийг амжилттай хүлээн авлаа. Төлбөр төлөгдсөний дараа хүргэлт хийгдэхийг анхаарна уу");
      final player = AudioCache();
      // player.play("sounds/success_bell.wav");
    } on DioError {
      // CustomDialogs.showSuccessDialog(false,
      //     "Захиалгын мэдээллийг илгээхэд алдаа гарлаа. Түр хүлээгээд дахин оролдоно уу.");
    }
    loading.value = false;
  }

  void filterByCategory(String text) async {
    allProducts.where((element) => element['category'] == text).toList();
  }

  void postUserData() async {
    var dio = Dio();
    await dio.post('/test', data: {'id': 12, 'name': 'wendu'});
  }

  void changeDeliveryTime(int n) {
    selectedTime.value = n;
  }

  void sendData() {
    // log(cartProducts.keys.runtimeType.toString());
    // log(cartProducts.values.toString());
    // log(cartProducts.runtimeType.toString());
    var ListCart = <Map>[];
    for (var i = 0; i < cartProducts.length; i++) {
      ListCart.add({
        "id": cartProducts.keys.toList()[i]['id'],
        "image": cartProducts.keys.toList()[i]['image'],
        "name": cartProducts.keys.toList()[i]['name'],
        "price": cartProducts.keys.toList()[i]['price'],
        "price1": cartProducts.keys.toList()[i]['price1'],
        "quantity": cartProducts.values.toList()[i],
        "store": cartProducts.keys.toList()[i]['store'],
        "too": cartProducts.keys.toList()[i]['too'],
      });
    }
    // generate6digit();
    var total = cartProducts.entries
        .map((e) => double.parse(e.key['price']) * e.value)
        .toList()
        .reduce((value, element) => value + element);
    Map<String, dynamic> _body = {
      "ListCart": ListCart,
      "Niit": total.toString(),
      "hayg": {
        "Address": addressController.value.text,
        "Kod": entranceController.value.text,
        "Phone": phoneController.value.text
      },
      // "id": rand.value.toString(),
      "now": DateFormat('MMM d y kk:mm').format(now).toString(),
      "radio": {"value": selectedTime.value}
    };
    postDataToTheServer(_body);
    // postDataToTheServer(_body);
  }
}
