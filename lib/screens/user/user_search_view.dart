import 'dart:convert';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/shimmer.dart';

class UserSearchView extends StatefulWidget {
  const UserSearchView({
    Key? key,
  }) : super(key: key);

  @override
  State<UserSearchView> createState() => _UserSearchViewState();
}

class _UserSearchViewState extends State<UserSearchView> {
  bool loading = false;
  dynamic _categoryData = [];
  dynamic _count = [];
  late AnimationController localAnimationController;
  final _navCtx = Get.put(NavigationController());

  @override
  void initState() {
    super.initState();
    readJson();
  }

  void readJson() async {
    String response =
        await rootBundle.loadString('assets/json/categories.json');
    dynamic data = await json.decode(response);
    setState(() {
      _categoryData = data;
      loading = true;
    });
    dynamic response1 =
        await RestApi().getProductCount({"typeCount": data.length + 1});
    dynamic d = Map<String, dynamic>.from(response1)['count'];
    setState(() {
      _count = d;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        customTitle: _title(),
        customActions: IconButton(
          onPressed: () {
            Get.toNamed(userQrScanScreenRoute);
          },
          icon: const Icon(
            IconlyLight.scan,
            color: MyColors.black,
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              color: MyColors.white,
              width: double.infinity,
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount:
                    _categoryData.length == 0 ? 14 : _categoryData.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  return _categoryData.isEmpty
                      ? MyShimmers().homeScreen()
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomInkWell(
                                onTap: () {
                                  if (_count[index]["count"] > 0) {
                                    _navCtx.title.value =
                                        _categoryData[index]["name"];
                                    _navCtx.typeId.value =
                                        _categoryData[index]["typeId"];
                                    _navCtx.searchViewController.value
                                        .jumpToPage(1);
                                  }
                                },
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  width: Get.width * .2,
                                  decoration: BoxDecoration(
                                    color: MyColors.fadedGrey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: _count.isNotEmpty &&
                                              _count[index]["count"] > 0
                                          ? Image(
                                              image: AssetImage(
                                                  "assets/images/png/categories/${_categoryData[index]['typeId']}.png"),
                                            )
                                          : Image(
                                              color: const Color.fromRGBO(
                                                  255, 255, 255, 0.1),
                                              colorBlendMode:
                                                  BlendMode.modulate,
                                              image: AssetImage(
                                                  "assets/images/png/categories/${_categoryData[index]['typeId']}.png"),
                                            )),
                                ),
                              ),
                              const SizedBox(height: 4),
                              CustomText(
                                text: "${_categoryData[index]['name']}",
                                fontSize: 14,
                                textAlign: TextAlign.center,
                                color: _count.isNotEmpty &&
                                        _count[index]["count"] > 0
                                    ? MyColors.black
                                    : MyColors.grey,
                              ),
                              const SizedBox(height: 4),
                              _count.isEmpty && loading
                                  ? CustomShimmer(
                                      width: Get.width * .2,
                                      height: 14,
                                    )
                                  : CustomText(
                                      text: _count.isNotEmpty
                                          ? "Нийт ${_count[index]["count"]} бараа"
                                          : "Нийт 0 бараа",
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: MyColors.grey,
                                    )
                            ],
                          ),
                        );
                },
              ),
            ),
          ],
        ));
  }
}

Widget _title() {
  return GestureDetector(
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
  );
}
