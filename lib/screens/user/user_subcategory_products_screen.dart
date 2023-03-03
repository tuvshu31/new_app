import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/products.dart';
import 'package:Erdenet24/controller/product_controller.dart';

class UserSubCategoryProductsScreen extends StatefulWidget {
  const UserSubCategoryProductsScreen({Key? key}) : super(key: key);

  @override
  State<UserSubCategoryProductsScreen> createState() =>
      _UserSubCategoryProductsScreenState();
}

class _UserSubCategoryProductsScreenState
    extends State<UserSubCategoryProductsScreen> {
  final _incoming = Get.arguments;
  final _prodCtrl = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    _prodCtrl.data.clear();
    _prodCtrl.typeId.value = _incoming["parentId"];
    _prodCtrl.categoryId.value = _incoming["id"];
    _prodCtrl.storeId.value = 0;
    _prodCtrl.page.value = 1;
    _prodCtrl.search.value = 0;
    _prodCtrl.callProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomHeader(
        customActions: Container(),
        title: _incoming["name"],
        subtitle:
            subtitle(_prodCtrl.loading.value, _prodCtrl.total.value, "бараа"),
        body: CustomData(),
      ),
    );
  }
}
