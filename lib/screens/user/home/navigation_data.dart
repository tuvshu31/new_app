import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/products.dart';
import 'package:Erdenet24/controller/product_controller.dart';

class NavigationData extends StatefulWidget {
  const NavigationData({Key? key}) : super(key: key);

  @override
  State<NavigationData> createState() => _NavigationDataState();
}

class _NavigationDataState extends State<NavigationData> {
  final _incoming = Get.arguments;
  final _prodCtrl = Get.put(ProductController());
  String role = "";

  @override
  void initState() {
    super.initState();
    _prodCtrl.data.clear();
    setState(() {
      role = _incoming["role"] ?? "";
    });
    bool isStore = role.isNotEmpty;
    _prodCtrl.typeId.value = isStore ? 0 : _incoming["parentId"];
    _prodCtrl.categoryId.value = isStore ? 0 : _incoming["id"];
    _prodCtrl.storeId.value = isStore ? _incoming["id"] : 0;
    _prodCtrl.page.value = 1;
    _prodCtrl.search.value = 0;
    _prodCtrl.callProducts();
  }

  //  arguments: {"id": 0, "name": _data["name"], "parentId": 1},
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomHeader(
        customActions: Container(),
        title: _incoming["name"],
        subtitle:
            subtitle(_prodCtrl.loading.value, _prodCtrl.total.value, "бараа"),
        body: const CustomData(),
      ),
    );
  }
}
