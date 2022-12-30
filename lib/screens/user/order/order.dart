import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/bottom_sheet.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/separator.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  final _cartCtrl = Get.put(CartController());
  final _navCtrl = Get.put(NavigationController());
  bool isPhoneOk = false;
  bool isAddressOk = false;
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController kod = TextEditingController();
  dynamic _user = [];
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    var query = {"id": RestApiHelper.getUserId()};
    dynamic res = await RestApi().getUsers(query);
    dynamic data = Map<String, dynamic>.from(res);
    _user = data["data"][0];
    phone.text =
        _user["deliveryPhone"] != null ? _user["deliveryPhone"].toString() : "";
    address.text = _user["deliveryAddress"] ?? "";
    kod.text = _user["deliveryKode"] ?? "";
    isPhoneOk = phone.text.isNotEmpty;
    isAddressOk = address.text.isNotEmpty;
    setState(() {});
  }

  void createOrder() async {
    loadingDialog(context);
    var body = {
      "orderId": _cartCtrl.generateOrderId(),
      "userId": RestApiHelper.getUserId(),
      "storeId1": _cartCtrl.stores.isNotEmpty ? _cartCtrl.stores[0] : null,
      "storeId2": _cartCtrl.stores.length > 1 ? _cartCtrl.stores[1] : null,
      "storeId3": _cartCtrl.stores.length > 2 ? _cartCtrl.stores[2] : null,
      "storeId4": _cartCtrl.stores.length > 3 ? _cartCtrl.stores[3] : null,
      "storeId5": _cartCtrl.stores.length > 4 ? _cartCtrl.stores[4] : null,
      "address": address.text,
      "orderStatus": "sent",
      "totalAmount": _cartCtrl.total,
      "orderTime": DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now()),
      "phone": phone.text,
      "kod": kod.text,
      "products": _cartCtrl.cartList,
    };
    dynamic response = await RestApi().createOrder(body);
    dynamic data = Map<String, dynamic>.from(response);
    log(data.toString());
    Get.back();
    successOrderModal(context, () {
      Get.back();
      Get.back();
      Get.back();
      _navCtrl.onItemTapped(4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _user.isNotEmpty
        ? Obx(() => CustomHeader(
              customActions: Container(),
              title: "Захиалгын мэдээлэл",
              bottomSheet: _bottomSheet(),
              body: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(text: "Утасны дугаар"),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hintText: "99352223",
                      controller: phone,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onChanged: (val) {
                        setState(() {
                          isPhoneOk = val.isNotEmpty;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    const CustomText(text: "Хүргүүлэх хаяг"),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hintText: "Согоот баг 6-20-31 тоот, 2-р орц, 3 давхарт",
                      controller: address,
                      textInputAction: TextInputAction.next,
                      onChanged: (val) {
                        setState(() {
                          isAddressOk = val.isNotEmpty;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        CustomText(text: "Орцны код "),
                        CustomText(
                          text: "/Заавал биш/",
                          fontSize: 12,
                          color: MyColors.gray,
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hintText: "#1234",
                      controller: kod,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          IconlyLight.info_circle,
                          color: MyColors.gray,
                          size: 16,
                        ),
                        SizedBox(width: 12),
                        Flexible(
                          child: CustomText(
                              fontSize: 12,
                              textAlign: TextAlign.justify,
                              color: MyColors.gray,
                              text:
                                  "Хүргэлт хүлээн авах мэдээллээ дэлгэрэнгүй оруулна уу. Хүргэлтийн мэдээллийг буруу оруулсан тохиолдолд хүргэлтийн төлбөр нэмэгдэж тооцогдохыг анхаарна уу"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ))
        : Material(child: Center(child: CircularProgressIndicator()));
  }

  Widget _bottomSheet() {
    return Container(
      width: Get.width,
      height: Get.height * .27,
      padding: const EdgeInsets.all(12),
      color: MyColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MySeparator(color: MyColors.grey),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(text: "Захиалгын үнэ:"),
              CustomText(
                text: convertToCurrencyFormat(
                  _cartCtrl.subTotal,
                  toInt: true,
                  locatedAtTheEnd: true,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "Хүргэлтийн үнэ:"),
              CustomText(
                text: convertToCurrencyFormat(
                  _cartCtrl.deliveryCost,
                  toInt: true,
                  locatedAtTheEnd: true,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "Нийт үнэ:"),
              CustomText(
                text: convertToCurrencyFormat(
                  _cartCtrl.total,
                  toInt: true,
                  locatedAtTheEnd: true,
                ),
              )
            ],
          ),
          SizedBox(height: Get.height * .03),
          CustomButton(
            text: "Төлбөр төлөх",
            isActive: isPhoneOk && isAddressOk,
            onPressed: () {
              List onTap = [
                () {
                  createOrder();
                }
              ];
              paymentBottomSheet(onTap);
            },
          )
        ],
      ),
    );
  }
}
