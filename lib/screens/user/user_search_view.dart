import 'package:Erdenet24/widgets/image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';

class UserSearchView extends StatefulWidget {
  const UserSearchView({
    Key? key,
  }) : super(key: key);

  @override
  State<UserSearchView> createState() => _UserSearchViewState();
}

class _UserSearchViewState extends State<UserSearchView> {
  bool loading = false;
  List categories = [];
  final _navCtx = Get.put(NavigationController());

  @override
  void initState() {
    super.initState();
    getMainCategories();
  }

  void getMainCategories() async {
    loading = true;
    dynamic response = await RestApi().getMainCategories();
    dynamic d = Map<String, dynamic>.from(response);
    if (d["success"]) {
      categories = d["data"];
    }
    loading = false;
    setState(() {});
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
        body: !loading && categories.isEmpty
            ? const CustomLoadingIndicator(text: "Ангилал олдсонгүй")
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: loading ? 12 : categories.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      var item = loading ? null : categories[index];
                      return loading
                          ? _shimmer()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomInkWell(
                                  onTap: () {
                                    if (!item["empty"]) {
                                      _navCtx.title.value = item["name"];
                                      _navCtx.typeId.value = item["id"];
                                      _navCtx.searchViewController.value
                                          .jumpToPage(1);
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    width: Get.width * .22,
                                    height: Get.width * .22,
                                    decoration: BoxDecoration(
                                      color: MyColors.fadedGrey,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: !item["empty"]
                                          ? Image.network(
                                              item["image"],
                                              width: Get.width * .16,
                                              height: Get.width * .16,
                                            )
                                          : Image(
                                              width: Get.width * .16,
                                              height: Get.width * .16,
                                              color: const Color.fromRGBO(
                                                  255, 255, 255, 0.1),
                                              colorBlendMode:
                                                  BlendMode.modulate,
                                              image: NetworkImage(
                                                "${URL.AWS}/main_category/${item["id"]}.png",
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                CustomText(
                                  text: item['name'] ?? "",
                                  fontSize: 14,
                                  textAlign: TextAlign.center,
                                  color: !item["empty"]
                                      ? MyColors.black
                                      : MyColors.grey,
                                ),
                              ],
                            );
                    },
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

Widget _shimmer() {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 0,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            width: Get.width * .2,
            decoration: BoxDecoration(
              color: MyColors.fadedGrey,
              shape: BoxShape.circle,
            ),
            child: CustomShimmer(
              width: Get.width * .2,
              height: Get.width * .2,
              borderRadius: 50,
            )),
        const SizedBox(height: 8),
        CustomShimmer(
          width: Get.width * .2,
          height: 16,
          borderRadius: 12,
        )
      ],
    ),
  );
}
