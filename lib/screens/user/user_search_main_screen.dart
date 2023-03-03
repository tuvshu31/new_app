import 'package:Erdenet24/widgets/loading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/search_bar.dart';
import 'package:Erdenet24/controller/product_controller.dart';

class UserSearchMainScreen extends StatefulWidget {
  const UserSearchMainScreen({Key? key}) : super(key: key);

  @override
  State<UserSearchMainScreen> createState() => _UserSearchMainScreenState();
}

class _UserSearchMainScreenState extends State<UserSearchMainScreen> {
  final _prodCtrl = Get.put(ProductController());
  bool _notChanged = true;
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _prodCtrl.page.value = 1;
    _prodCtrl.hasMore.value = false;
    _prodCtrl.categoryId.value = 0;
    _prodCtrl.data.clear();
  }

  void onChanged() async {
    if (_searchController.text.isEmpty) {
      _notChanged = true;
    }
  }

  void onSubmitted() async {
    if (_searchController.text.isNotEmpty) {
      _notChanged = false;
      _prodCtrl.search.value = 0;
      _prodCtrl.page.value = 1;
      _prodCtrl.search.value = 1;
      _prodCtrl.searchText.value = _searchController.text;
      _prodCtrl.data.clear();
      _prodCtrl.callProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomHeader(
          isMainPage: false,
          customActions: SizedBox(
            child: CustomText(text: _prodCtrl.search.toString()),
          ),
          customTitle: CustomSearchBar(
            controller: _searchController,
            onSubmitted: onSubmitted,
            hintText: 'Бараа хайх...',
            autoFocus: true,
            onChanged: onChanged,
          ),
          body: _notChanged
              ? Container()
              : _prodCtrl.data.isEmpty
                  ? const CustomLoadingIndicator(
                      text: "Хайлтын илэрц олдсонгүй")
                  // : const CustomData(),
                  : Container()),
    );
  }
}
