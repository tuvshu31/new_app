import 'dart:convert';
import 'package:Erdenet24/screens/user/home/product_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/snackbar.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  int _selectedIndex = 0;
  dynamic _categories = [];
  dynamic _subCategories = [];
  final PageController _pageController = PageController();
  //Үндсэн ангиллуудыг дуудах;
  Future<void> readJson() async {
    String _catStr = await rootBundle.loadString('assets/json/categories.json');
    dynamic categories = await json.decode(_catStr);
    setState(() {
      _categories = categories;
    });
    callSubCategories();
  }

  // Дэд ангиллуудыг дуудах;
  Future<void> callSubCategories() async {
    dynamic _subCatStr = await RestApi()
        .getCategories({"parentId": _categories[_selectedIndex]['parentId']});
    if (_subCatStr['success'] == true) {
      setState(() {
        _subCategories = _subCatStr['data'];
      });
    } else {
      errorSnackBar(_subCatStr['success'].toString(), 3, context);
    }
  }

  @override
  void initState() {
    super.initState();
    readJson();
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
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 5,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () async {
                setState(() {
                  _selectedIndex = index;
                  _pageController.jumpToPage(index);
                });
                callSubCategories();
              },
              child: Container(
                  alignment: Alignment.center,
                  height: 90,
                  color: _selectedIndex == index
                      ? MyColors.white
                      : Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(
                              "assets/images/png/categories/${_categories[index]['parentId']}.png"),
                          width: 40,
                        ),
                        CustomText(
                          text: "${_categories[index]['name']}",
                          fontSize: 12,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )));
        },
      ),
    );
  }

  Widget _categoryItems() {
    return Expanded(
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          Column(
            children: [
              SizedBox(
                  width: double.infinity,
                  height: Get.height * .05,
                  child: Center(
                      child: CustomText(
                    text: _selectedIndex == 0
                        ? "Хүнс"
                        : _categories[_selectedIndex]['name'],
                    fontWeight: FontWeight.bold,
                  ))),
              Expanded(
                child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _subCategories.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomInkWell(
                              onTap: () {
                                Get.toNamed("/CategoryNoTabbar",
                                    arguments: _subCategories[index]);
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                width: Get.width * .15,
                                decoration: BoxDecoration(
                                  color: MyColors.background.withAlpha(92),
                                  shape: BoxShape.circle,
                                ),
                                child: CachedImage(
                                  image:
                                      "${URL.AWS}/categories/${_subCategories[index]['image']}",
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            CustomText(
                              text: "${_subCategories[index]['name']}",
                              textAlign: TextAlign.center,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        ],
      ),
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
      size: 18,
      color: MyColors.black,
    ),
  );
}
