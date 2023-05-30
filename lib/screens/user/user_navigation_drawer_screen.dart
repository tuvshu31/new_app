import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/screens/user/user_product_detail_screen.dart';
import 'package:Erdenet24/screens/user/user_products_screen.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:shimmer/shimmer.dart';

class UserNavigationDrawerScreen extends StatefulWidget {
  const UserNavigationDrawerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UserNavigationDrawerScreen> createState() =>
      _UserNavigationDrawerScreenState();
}

class _UserNavigationDrawerScreenState
    extends State<UserNavigationDrawerScreen> {
  int _selectedIndex = 0;
  List _categories = [];
  List _subCategories = [];
  bool fetchingSubCategories = false;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    String catStr = await rootBundle.loadString('assets/json/categories.json');
    dynamic categories = await json.decode(catStr);
    _categories = categories;
    setState(() {});
    fetchSubCategories();
  }

  Future<void> fetchSubCategories() async {
    fetchingSubCategories = true;
    dynamic subCatStr = await RestApi()
        .getCategories({"parentId": _categories[_selectedIndex]['typeId']});
    if (subCatStr['success'] == true) {
      _subCategories.clear();
      _subCategories = subCatStr['data'];
    }
    fetchingSubCategories = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: double.infinity,
        child: CustomHeader(
          title: 'Ангилал',
          customActions: Container(),
          customLeading: _leading(),
          body: Row(
            children: [
              _categoryList(),
              _categoryItems(),
            ],
          ),
        ));
  }

  Widget _categoryList() {
    return Container(
      color: MyColors.fadedGrey,
      width: Get.width * .25,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: _categories.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                _selectedIndex = index;
                _pageController.jumpToPage(index);
                setState(() {});
                fetchSubCategories();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: _selectedIndex == index
                    ? MyColors.white
                    : Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(
                          "assets/images/png/categories/${_categories[index]['typeId']}.png"),
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      text: "${_categories[index]['name']}",
                      fontSize: 12,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _categoryItems() {
    return Expanded(
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          !fetchingSubCategories && _subCategories.isEmpty
              ? const Center(
                  child: CustomLoadingIndicator(
                    text: 'Ангилал хоосон байна',
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                        width: double.infinity,
                        height: Get.height * .05,
                        child: Center(
                            child: fetchingSubCategories
                                ? CustomShimmer(
                                    width: Get.width * .2,
                                    height: 14,
                                    isRoundedCircle: true,
                                  )
                                : CustomText(
                                    text: _selectedIndex == 0
                                        ? "Хүнс"
                                        : _categories[_selectedIndex]['name'],
                                    fontWeight: FontWeight.bold,
                                  ))),
                    Expanded(
                      child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: fetchingSubCategories
                              ? 10
                              : _subCategories.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.2,
                          ),
                          itemBuilder: (context, index) {
                            if (fetchingSubCategories) {
                              return _subCategoryShimmer();
                            } else {
                              return _subCategoryItem(_subCategories[index]);
                            }
                          }),
                    )
                  ],
                ),
        ],
      ),
    );
  }

  Widget _subCategoryShimmer() {
    return Column(
      children: [
        CustomShimmer(
          width: Get.width * .15,
          height: Get.width * .15,
          isCircle: true,
        ),
        const SizedBox(height: 8),
        CustomShimmer(
          width: Get.width * .2,
          height: 12,
          isRoundedCircle: true,
        )
      ],
    );
  }

  Widget _subCategoryItem(item) {
    return Column(
      children: [
        CustomInkWell(
          onTap: () {
            Get.to(
              UserProductsScreen(
                navType: NavType.none,
                title: item["name"],
                typeId: item["parentId"],
                categoryId: item["id"],
              ),
            );
          },
          borderRadius: BorderRadius.circular(50),
          child: SizedBox(
            width: Get.width * .15,
            child: Image.network(
              "${URL.AWS}/categories/${item['image']}",
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Container(
                  width: Get.width * .15,
                  height: Get.width * .15,
                  decoration: BoxDecoration(
                    color: MyColors.fadedGrey,
                    shape: BoxShape.circle,
                  ),
                  child: const CupertinoActivityIndicator(),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: Get.width * .3,
          child: CustomText(
            text: "${item['name']}",
            textAlign: TextAlign.center,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

Widget _leading() {
  return IconButton(
    onPressed: () {
      Get.back();
    },
    icon: const Icon(
      Icons.clear_rounded,
      size: 24,
      color: MyColors.black,
    ),
  );
}
