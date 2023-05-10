import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UserOrderPaymentScreen extends StatefulWidget {
  const UserOrderPaymentScreen({Key? key}) : super(key: key);

  @override
  State<UserOrderPaymentScreen> createState() => _UserOrderPaymentScreenState();
}

class _UserOrderPaymentScreenState extends State<UserOrderPaymentScreen> {
  final _incoming = Get.arguments;
  final _userCtx = Get.put(UserController());
  PageController pageController = PageController(initialPage: 0);

  List bankList = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      bankList = _incoming['data']['urls'];
    });
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void navgiteToDeepLink(int index) async {
    loadingDialog(context);
    _launchUrl(Uri.parse(_incoming["data"]["urls"][index]["link"]));
    Get.back();
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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Image.memory(
            base64Decode(_incoming["data"]["qr_image"]),
            width: Get.width * .4,
            height: Get.width * .4,
          ),
          const SizedBox(height: 12),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 12, right: 12, left: 12),
            separatorBuilder: (context, index) {
              return const SizedBox(height: 14);
            },
            physics: const BouncingScrollPhysics(),
            itemCount: bankList.length,
            itemBuilder: (context, index) {
              var bank = bankList[index];
              return CustomInkWell(
                onTap: () {
                  navgiteToDeepLink(index);
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
            },
          ),
          const SizedBox(height: 12),
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
