import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/screens/store/edit_products/create_product.dart';
import 'package:Erdenet24/screens/store/edit_products/edit_products.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:get/get.dart';

class OrderPaymentView extends StatefulWidget {
  const OrderPaymentView({Key? key}) : super(key: key);

  @override
  State<OrderPaymentView> createState() => _OrderPaymentViewState();
}

class _OrderPaymentViewState extends State<OrderPaymentView> {
  final _cartCtrl = Get.put(CartController());
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
    return Column(
      children: [
        SizedBox(height: Get.height * .03),
        CustomText(text: "Төлөх дүн:"),
        SizedBox(height: 8),
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
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: MyColors.fadedGrey,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image(
                          width: Get.width * .1,
                          image: AssetImage(
                              "assets/images/png/bank/${bankList[index]["image"]}"),
                        ),
                        CustomText(text: bankList[index]["name"])
                      ]),
                );
              }),
        ),
      ],
    );
  }

  Widget _loanView() {
    return const Center(
        child: CustomLoadingIndicator(
      text: "Тун удахгүй...",
    ));
  }
}
