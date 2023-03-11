import 'dart:developer';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/screens/user/user_orders_active_screen.dart';
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
import 'package:url_launcher/url_launcher.dart';

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
  List bankList = [];
  int bankIndex = 0;
  @override
  void initState() {
    super.initState();
    callBankList();
  }

  Future<void> callBankList() async {
    String banks = await rootBundle.loadString('assets/json/banks.json');
    dynamic banksJson = await json.decode(banks);
    setState(() {
      bankList = banksJson;
    });
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void createOrder(int bankIndex) async {
    loadingDialog(context);
    int userId = RestApiHelper.getUserId();
    int randomNumber = random4digit();
    var orderId = int.parse(("$userId" "$randomNumber"));
    var orderBody = {
      "orderId": orderId,
      "userId": RestApiHelper.getUserId(),
      "storeId1": _cartCtrl.stores.isNotEmpty ? _cartCtrl.stores[0] : null,
      "storeId2": _cartCtrl.stores.length > 1 ? _cartCtrl.stores[1] : null,
      "storeId3": _cartCtrl.stores.length > 2 ? _cartCtrl.stores[2] : null,
      "storeId4": _cartCtrl.stores.length > 3 ? _cartCtrl.stores[3] : null,
      "storeId5": _cartCtrl.stores.length > 4 ? _cartCtrl.stores[4] : null,
      "address": _incoming["address"],
      "orderStatus": "notPaid",
      "totalAmount": _cartCtrl.total,
      "orderTime": DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now()),
      "phone": _incoming["phone"],
      "kod": _incoming["kode"],
      "products": _cartCtrl.cartList,
    };
    // log(body.toString());
    dynamic orderResponse = await RestApi().createOrder(orderBody);
    dynamic orderData = Map<String, dynamic>.from(orderResponse);
    var qpayBody = {"sender_invoice_no": orderId.toString(), "amount": 100};
    dynamic qpayResponse = await RestApi().qpayPayment(qpayBody);
    dynamic qpayData = Map<String, dynamic>.from(qpayResponse);
    Get.back();
    if (qpayData["success"]) {
      dynamic resString = json.decode(qpayData["data"]);
      _launchUrl(Uri.parse(resString["urls"][bankIndex]["link"]));
      // log(resString["urls"].toString());
      // moveToOrderStatusView(data["data"]);
    }
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
      child: SingleChildScrollView(
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
            const SizedBox(height: 12),
            GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: bankList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  var bank = bankList[index];
                  return Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: MyColors.fadedGrey,
                        borderRadius: BorderRadius.circular(12)),
                    child: CustomInkWell(
                      onTap: (() {
                        createOrder(index);
                        // khanbankcheck();

                        // log(index.toString());
                        // Get.to(const UserOrderNotificationScreen());
                      }),
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                width: Get.width * .1,
                                image: AssetImage(
                                    "assets/images/png/bank/${bank["id"]}.png"),
                              ),
                              SizedBox(height: 6),
                              CustomText(
                                text: bank["name"],
                                fontSize: 12,
                                textAlign: TextAlign.center,
                              )
                            ]),
                      ),
                    ),
                  );
                }),
          ],
        ),
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
