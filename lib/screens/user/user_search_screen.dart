import 'package:Erdenet24/controller/data_controller.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';

import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  bool loading = false;
  bool storeLoading = false;
  List categories = [];
  List storeList = [];
  String title = "";
  PageController controller = PageController();
  final _navCtx = Get.put(NavigationController());
  final _dataCtx = Get.put(DataController());

  @override
  void initState() {
    super.initState();
    getMainCategories();
  }

  void getMainCategories() async {
    if (_dataCtx.categories.isEmpty) {
      loading = true;
      dynamic getMainCategories = await UserApi().getMainCategories();
      dynamic response = Map<String, dynamic>.from(getMainCategories);
      if (response["success"]) {
        categories = response["data"];
      }
      loading = false;
    } else {
      categories = _dataCtx.categories;
    }
    setState(() {});
  }

  void getStoreList(int category) async {
    storeLoading = true;
    dynamic getMainCategories = await UserApi().getStoreList(category);
    dynamic response = Map<String, dynamic>.from(getMainCategories);
    if (response["success"]) {
      storeList = response["data"];
    }
    storeLoading = false;
    setState(() {});
  }

  void animateToPage(int id) {
    controller.animateToPage(
      id,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    storeList.clear();
    storeLoading = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: controller,
      children: [
        _homeScreenMainView(),
        _homeScreenStoreListView(),
      ],
    );
  }

  Widget _homeScreenMainView() {
    return CustomHeader(
      customLeading: IconButton(
        onPressed: () {
          _navCtx.openDrawer();
        },
        icon: const Icon(
          Icons.menu_rounded,
          color: MyColors.black,
        ),
      ),
      customTitle: GestureDetector(
        onTap: () => Get.toNamed(userSearchBarScreenRoute),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 40,
          decoration: BoxDecoration(
            color: MyColors.background.withAlpha(92),
            borderRadius: BorderRadius.circular(
              50,
            ),
          ),
          child: Row(
            children: const [
              Icon(
                IconlyLight.search,
                color: MyColors.primary,
                size: 18,
              ),
              SizedBox(width: 12),
              CustomText(
                text: "Та юу хайж байна?",
                color: MyColors.gray,
                fontSize: 14,
              ),
            ],
          ),
        ),
      ),
      customActions: IconButton(
        onPressed: () {
          Get.toNamed(userQrScanScreenRoute);
        },
        icon: const Icon(
          IconlyLight.scan,
          color: MyColors.black,
        ),
      ),
      body: loading
          ? _shimmerWidget()
          : categories.isEmpty
              ? customEmptyWidget("Ангилал олдсонгүй")
              : _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return Container(
      color: MyColors.background.withAlpha(92),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _button(1),
                _button(2),
                _button(3),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _button(4),
                _button(5),
                _button(6),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _button(7),
                _button(8),
                _button(9),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _button(int index) {
    var item = categories[index - 1];
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: CustomInkWell(
          onTap: () {
            title = item["name"];
            setState(() {});
            animateToPage(1);
            getStoreList(item["id"]);
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customImage(
                  Get.width * .16,
                  item["image"],
                  isCircle: true,
                ),
                SizedBox(height: Get.height * .04),
                Text(
                  item["name"] ?? "",
                  style: TextStyle(
                    color: !item["empty"] ? MyColors.black : MyColors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _homeScreenStoreListView() {
    return CustomHeader(
      customLeading: CustomInkWell(
        onTap: () {
          animateToPage(0);
        },
        child: const Center(
          child: Icon(
            IconlyLight.arrow_left,
            color: MyColors.black,
            size: 20,
          ),
        ),
      ),
      title: title,
      customActions: Container(),
      body: storeLoading && storeList.isEmpty
          ? listShimmerWidget()
          : !storeLoading && storeList.isEmpty
              ? customEmptyWidget("Дэлгүүр байхгүй байна")
              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return Container();
                  },
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: storeList.isEmpty ? 6 : storeList.length,
                  itemBuilder: (context, index) {
                    if (storeList.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      var data = storeList[index];
                      return CustomInkWell(
                        onTap: () {
                          Get.toNamed(userProductsScreenRoute, arguments: {
                            "title": data["name"],
                            "id": data["id"]
                          });
                        },
                        borderRadius: BorderRadius.zero,
                        child: SizedBox(
                          height: Get.width * .2 + 16,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                customImage(
                                  Get.width * .2,
                                  data["image"],
                                  isCircle: true,
                                  isFaded: data["isOpen"] == 0,
                                  fadeText: "Хаалттай",
                                ),
                                SizedBox(width: Get.width * .05),
                                SizedBox(
                                  width: Get.width * .6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        data["name"],
                                        style: const TextStyle(
                                          color: MyColors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        data["description"],
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Expanded(
                                  child: Center(
                                    child: Icon(
                                      IconlyLight.arrow_right_2,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
    );
  }

  Widget _shimmerWidget() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              _shimmer(),
              _shimmer(),
              _shimmer(),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _shimmer(),
              _shimmer(),
              _shimmer(),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _shimmer(),
              _shimmer(),
              _shimmer(),
            ],
          ),
        )
      ],
    );
  }

  Widget _shimmer() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: Get.width * .16,
                height: Get.width * .16,
                child: CustomShimmer(
                  width: Get.width * .16,
                  height: Get.width * .16,
                  isCircle: true,
                ),
              ),
              SizedBox(height: Get.height * .04),
              SizedBox(
                width: Get.width * .16,
                height: 16,
                child: CustomShimmer(
                  width: Get.width * .16,
                  height: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
