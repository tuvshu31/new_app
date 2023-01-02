import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/screens/user/order/payment.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/separator.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

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
    if (_user["deliveryPhone"] != null && _user["deliveryPhone"] != 0) {
      phone.text = _user["deliveryPhone"].toString();
    }
    if (_user["deliveryAddress"] != null &&
        _user["deliveryAddress"].isNotEmpty) {
      address.text = _user["deliveryAddress"];
    }
    if (_user["deliveryKode"] != null && _user["deliveryKode"].isNotEmpty) {
      kod.text = _user["deliveryKode"];
    }
    isPhoneOk = phone.text.isNotEmpty;
    isAddressOk = address.text.isNotEmpty;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomHeader(
          customActions: Container(),
          title: "Захиалгын мэдээлэл",
          bottomSheet: _bottomSheet(),
          body: _user.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(text: "Утасны дугаар"),
                      const SizedBox(height: 12),
                      CustomTextField(
                        hintText: "99352223",
                        controller: phone,
                        maxLength: 8,
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
                        hintText: "3-24-р байр, 9 давхарт 1165 тоот",
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
                )
              : MyShimmers().userPage(),
        ));
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
              Get.to(() => const OrderPaymentView(), arguments: {
                "phone": phone.text,
                "address": address.text,
                "kode": kod.text
              });
            },
          )
        ],
      ),
    );
  }
}
