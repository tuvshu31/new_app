import 'package:Erdenet24/screens/store/store_products_create_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/screens/store/store_products_edit_products_screen.dart';

class StoreProductsEditMainScreen extends StatefulWidget {
  const StoreProductsEditMainScreen({Key? key}) : super(key: key);

  @override
  State<StoreProductsEditMainScreen> createState() =>
      _StoreProductsEditMainScreenState();
}

class _StoreProductsEditMainScreenState
    extends State<StoreProductsEditMainScreen> {
  @override
  void initState() {
    super.initState();
  }

  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      withTabBar: true,
      title: "Бараа нэмэх, засах",
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
                  text: "Шинээр нэмэх",
                ),
                Tab(
                  text: "Засах",
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: const [
                StoreProductsCreateProductScreen(),
                StoreProductsEditProductsScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
