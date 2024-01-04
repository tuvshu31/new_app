import 'dart:async';
import 'dart:developer';

import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class UserSearchBarScreenRoute extends StatefulWidget {
  const UserSearchBarScreenRoute({super.key});

  @override
  State<UserSearchBarScreenRoute> createState() =>
      _UserSearchBarScreenRouteState();
}

class _UserSearchBarScreenRouteState extends State<UserSearchBarScreenRoute> {
  List products = [];
  bool searching = false;
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Timer? _debounceTimer;
  void _onTypingFinished(String text) {
    searching = true;
    products.clear();
    setState(() {});
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(seconds: 1), () async {
      if (text.isNotEmpty) {
        String keyWord = searchController.text;
        dynamic searchUserAllProducts =
            await UserApi().searchUserAllProducts(keyWord);
        searching = false;
        if (searchUserAllProducts != null) {
          dynamic response = Map<String, dynamic>.from(searchUserAllProducts);
          if (response["success"]) {
            products = response["data"];
            log(products.toString());
          }
        }
      } else {
        searching = false;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      customLeading: CustomInkWell(
        onTap: () {
          Get.back();
        },
        child: const SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Icon(
            IconlyLight.arrow_left,
            color: MyColors.black,
            size: 20,
          ),
        ),
      ),
      customActions: Container(),
      actionWidth: 24,
      customTitle: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: MyColors.fadedGrey,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 12),
              child: Center(
                child: searching
                    ? const CupertinoActivityIndicator()
                    : const Icon(
                        IconlyLight.search,
                        color: MyColors.primary,
                        size: 20,
                      ),
              ),
            ),
            Expanded(
              child: TextField(
                textInputAction: TextInputAction.search,
                autofocus: true,
                controller: searchController,
                decoration: const InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  hintText: "Хайлт жишээ нь: сүү, бууз гм",
                  hintStyle: TextStyle(
                    fontSize: MyFontSizes.normal,
                    color: MyColors.gray,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: MyDimentions.borderWidth,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: MyDimentions.borderWidth,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: MyDimentions.borderWidth,
                    ),
                  ),
                ),
                style: const TextStyle(
                  fontSize: MyFontSizes.large,
                  color: MyColors.black,
                ),
                cursorColor: MyColors.primary,
                cursorWidth: 1.5,
                onSubmitted: (value) {},
                onChanged: (val) {
                  _onTypingFinished(val);
                },
              ),
            ),
            searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      searchController.clear();
                      products.clear();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      color: MyColors.gray,
                      size: 18,
                    ),
                  )
                : Container()
          ],
        ),
      ),
      body: !searching && searchController.text.isEmpty
          ? customEmptyWidget("Хайх үгээ оруулна уу")
          : ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: searching ? 12 : products.length,
              separatorBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: double.infinity,
                  height: Get.height * .008,
                  decoration: BoxDecoration(color: MyColors.fadedGrey),
                );
              },
              padding: const EdgeInsets.only(top: 12),
              itemBuilder: (context, index) {
                if (index < products.length) {
                  var item = products[index];
                  return listItemWidget(item, () {
                    Get.offNamed(userProductsScreenRoute, arguments: {
                      "title": item["storeName"],
                      "id": item["store"],
                      "isOpen": item["isOpen"] == true ? 1 : 0
                    });
                  });
                } else if (searching) {
                  return itemShimmer();
                } else {
                  return Container();
                }
              },
            ),
    );
  }

  //  var item = _userCtx.filteredOrderList[index];
  Widget listItemWidget(
    Map item,
    VoidCallback onClicked,
  ) {
    return CustomInkWell(
      borderRadius: BorderRadius.zero,
      onTap: onClicked,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: Get.width * .04),
          customImage(Get.width * .12, item["image"], isCircle: true),
          SizedBox(width: Get.width * .04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: item["storeName"],
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                item["description"] ?? "",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              )
            ],
          ),
          const Spacer(),
          const Icon(
            IconlyLight.arrow_right_2,
            size: 20,
          ),
          SizedBox(width: Get.width * .04),
        ],
      ),
    );
  }

  Widget itemShimmer() {
    return SizedBox(
      height: Get.height * .07,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: Get.width * .04),
            Stack(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Get.width * 0.12,
                    maxHeight: Get.width * 0.12,
                  ),
                  child: CustomShimmer(
                    width: Get.width * .12,
                    height: Get.width * .12,
                    borderRadius: 50,
                  ),
                ),
              ],
            ),
            SizedBox(width: Get.width * .04),
            CustomShimmer(width: Get.width * .65, height: 16),
          ],
        ),
      ),
    );
  }
}
