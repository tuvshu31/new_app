import 'package:Erdenet24/utils/styles.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/products.dart';
import 'package:Erdenet24/widgets/search_bar.dart';
import 'package:Erdenet24/controller/product_controller.dart';

class SearchScreenMain extends StatefulWidget {
  const SearchScreenMain({Key? key}) : super(key: key);

  @override
  State<SearchScreenMain> createState() => _SearchScreenMainState();
}

class _SearchScreenMainState extends State<SearchScreenMain> {
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
        customActions: Container(
          child: CustomText(text: "${_prodCtrl.search.toString()}"),
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
            : _prodCtrl.data.length == 0
                ? _emptyResult()
                : const CustomData(),
      ),
    );
  }
}

Widget _emptyResult() {
  return SizedBox(
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: Get.height * .2,
        ),
        Image(
          image: const AssetImage("assets/images/png/app/search.png"),
          width: Get.width * .3,
        ),
        SizedBox(
          height: Get.height * .04,
        ),
        const CustomText(
          text: "Хайлтын илэрц олдсонгүй",
          color: MyColors.gray,
        )
      ],
    ),
  );
}
