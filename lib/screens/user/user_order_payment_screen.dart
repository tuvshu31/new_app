import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/screens/user/user_order_notification_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserOrderPaymentScreen extends StatefulWidget {
  const UserOrderPaymentScreen({Key? key}) : super(key: key);

  @override
  State<UserOrderPaymentScreen> createState() => _UserOrderPaymentScreenState();
}

class _UserOrderPaymentScreenState extends State<UserOrderPaymentScreen> {
  final _cartCtrl = Get.put(CartController());
  final _navCtrl = Get.put(NavigationController());
  final _incoming = Get.arguments;

  final _notifications = FlutterLocalNotificationsPlugin();

  PageController pageController = PageController(initialPage: 0);
  List bankList = [
    {"name": "Хаан", "image": "khaan.png"},
    {"name": "TDB", "image": "tdb.png"},
    {"name": "Голомт", "image": "golomt.png"},
    {"name": "Most Money", "image": "most_money.png"},
    {"name": "Хас", "image": "khas.png"},
    {"name": "Төрийн", "image": "state.png"},
    {"name": "Капитрон", "image": "capitron.png"},
  ];
  @override
  void initState() {
    super.initState();
    print(_incoming);
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
      "address": _incoming["address"],
      "orderStatus": "sent",
      "totalAmount": _cartCtrl.total,
      "orderTime": DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now()),
      "phone": _incoming["phone"],
      "kod": _incoming["kode"],
      "products": _cartCtrl.cartList,
    };
    dynamic response = await RestApi().createOrder(body);
    dynamic data = Map<String, dynamic>.from(response);
    log(data.toString());
    Get.back();
    successOrderModal(context, () {
      _cartCtrl.cartList.clear();
      Get.back();
      Get.back();
      Get.back();
      _navCtrl.onItemTapped(4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      withTabBar: true,
      title: "Төлбөр төлөх",
      customActions: Container(),
      body: Column(
        children: [
          DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: TabBar(
              onTap: ((value) {
                pageController.animateToPage(
                  value,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.bounceInOut,
                );
              }),
              labelColor: MyColors.primary,
              unselectedLabelColor: MyColors.black,
              indicatorColor: MyColors.primary,
              tabs: const [
                Tab(
                  text: "Бэлнээр",
                ),
                Tab(
                  text: "Зээлээр",
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                _cashView(),
                _loanView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cashView() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Get.width * .05),
      child: Column(
        children: [
          SizedBox(height: Get.height * .03),
          const CustomText(text: "Төлөх дүн:"),
          const SizedBox(height: 8),
          CustomText(
            fontSize: 18,
            color: MyColors.primary,
            text: convertToCurrencyFormat(
              _cartCtrl.total,
              toInt: true,
              locatedAtTheEnd: true,
            ),
          ),
          SizedBox(height: Get.height * .05),
          Expanded(
            child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: bankList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: MyColors.fadedGrey,
                        borderRadius: BorderRadius.circular(12)),
                    child: CustomInkWell(
                      onTap: (() {
                        createOrder();
                        // Get.to(const UserOrderNotificationScreen());
                      }),
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image(
                                width: Get.width * .1,
                                image: AssetImage(
                                    "assets/images/png/bank/${bankList[index]["image"]}"),
                              ),
                              CustomText(
                                text: bankList[index]["name"],
                              )
                            ]),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _loanView() {
    return const Center(
        child: CustomLoadingIndicator(
      text: "Тун удахгүй...",
    ));
  }
}
