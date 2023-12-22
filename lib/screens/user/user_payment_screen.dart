import 'dart:convert';

import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/api/socket_instance.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPaymentScreen extends StatefulWidget {
  const UserPaymentScreen({Key? key}) : super(key: key);

  @override
  State<UserPaymentScreen> createState() => _UserPaymentScreenState();
}

class _UserPaymentScreenState extends State<UserPaymentScreen> {
  final _arguments = Get.arguments;
  bool loading = true;
  PageController pageController = PageController(initialPage: 0);
  List bankList = [];
  String qrImage = "";
  final _navCtx = Get.put(NavigationController());
  int userId = RestApiHelper.getUserId();

  @override
  void initState() {
    super.initState();
    SocketClient().connect();
    createQpayInvoice();
  }

  void createQpayInvoice() async {
    loading = true;
    var body = {
      "orderId": _arguments["orderId"],
      "amount": _arguments["amount"]
    };
    dynamic createQpayInvoice = await UserApi().createQpayInvoice(body);
    loading = false;
    if (createQpayInvoice != null) {
      dynamic response = Map<String, dynamic>.from(createQpayInvoice);
      if (response["success"]) {
        var data = jsonDecode(response["data"]);
        qrImage = data["qr_image"];
        bankList = data["urls"];
      }
    }
    setState(() {});
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
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
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      loading
                          ? CustomShimmer(
                              width: Get.width * .4,
                              height: Get.width * .4,
                            )
                          : Image.memory(
                              base64Decode(qrImage),
                              width: Get.width * .4,
                              height: Get.width * .4,
                            ),
                      const SizedBox(height: 12),
                      ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding:
                            const EdgeInsets.only(top: 12, right: 12, left: 12),
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 14);
                        },
                        physics: const BouncingScrollPhysics(),
                        itemCount: loading ? 8 : bankList.length,
                        itemBuilder: (context, index) {
                          if (loading) {
                            return _shimmerWidget();
                          } else {
                            var bank = bankList[index];
                            return CustomInkWell(
                              onTap: () {
                                _launchUrl(bank["link"]);
                              },
                              child: Card(
                                elevation: 1,
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  leading: Container(
                                    width: Get.width * .09,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Image.network(
                                      bank["logo"],
                                    ),
                                  ),
                                  title: CustomText(
                                    text: bank["description"],
                                    fontSize: 14,
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18,
                                    color: MyColors.black,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                _loanView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _loanView() {
    return Center(
        child: customEmptyWidget(
      "Тун удахгүй...",
    ));
  }

  Widget _shimmerWidget() {
    return SizedBox(
      height: Get.width * .2 + 16,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: Get.width * .04),
            Stack(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Get.width * 0.2,
                    maxHeight: Get.width * 0.2,
                  ),
                  child: CustomShimmer(
                    width: Get.width * .2,
                    height: Get.width * .2,
                    borderRadius: 50,
                  ),
                ),
              ],
            ),
            SizedBox(width: Get.width * .04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomShimmer(width: Get.width * .65, height: 16),
                  CustomShimmer(width: Get.width * .65, height: 16),
                  CustomShimmer(width: Get.width * .65, height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
