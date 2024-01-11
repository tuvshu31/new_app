import 'dart:async';
import 'dart:developer';
import 'package:Erdenet24/api/dio_requests/store.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/custom_dialogs.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';
import 'package:Erdenet24/widgets/custom_loading_widget.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class StoreProductsEditScreen extends StatefulWidget {
  const StoreProductsEditScreen({super.key});

  @override
  State<StoreProductsEditScreen> createState() =>
      _StoreProductsEditScreenState();
}

class _StoreProductsEditScreenState extends State<StoreProductsEditScreen> {
  bool loading = false;
  bool hasMore = false;
  List products = [];
  int page = 1;
  int totalCount = 0;
  List categories = [];
  Map pagination = {};
  List<int> selectedIndex = [];
  bool showSearchBar = false;
  Map sort = {};
  String categoryTitle = "Ангилал";
  String sortTitle = "Эрэмбэлэх";
  bool showUptoTopButton = false;
  List<Map<dynamic, dynamic>> sortValues = [
    {"name": "Үнэ өсөхөөр", "icon": IconlyLight.arrow_up, "sort": "price"},
    {"name": "Үнэ буурахаар", "icon": IconlyLight.arrow_down, "sort": "-price"},
    {"name": "A-Z", "icon": Icons.text_increase, "sort": "name"},
    {"name": "Z-A", "icon": Icons.text_decrease, "sort": "-name"},
    {"name": "Хямдралтай нь эхэндээ", "icon": Icons.tag, "sort": "salePercent"},
  ];
  TextEditingController searchController = TextEditingController();
  TextEditingController availableController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getStoreCategoryList();
    getStoreProducts();
    scrollHandler();
  }

  void scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
  }

  Timer? _debounceTimer;

  void _onTypingFinished(String text) {
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      log('Typing finished: $text');
      page = 1;
      products.clear();
      setState(() {});
      if (text.isNotEmpty) {
        searchStoreProducts();
      }
    });
  }

  void getStoreProducts() async {
    loading = true;
    dynamic typeId = 0;
    if (selectedIndex.length == 1) {
      if (selectedIndex.contains(0)) {
        typeId = 0;
      } else {
        typeId = selectedIndex[0];
      }
    } else {
      typeId = selectedIndex;
    }
    var query = {
      "limit": 15,
      "page": page,
      "typeId": typeId,
      "sort": sort.isEmpty ? 0 : sort["sort"]
    };
    query.removeWhere((key, value) => value == 0);
    dynamic getStoreProducts = await StoreApi().getStoreProducts(query);
    loading = false;
    setState(() {});
    if (getStoreProducts != null) {
      dynamic response = Map<String, dynamic>.from(getStoreProducts);
      if (response["success"]) {
        products = products + response["data"];
      }
      pagination = response["pagination"];
      if (pagination["pageCount"] > page) {
        hasMore = true;
      } else {
        hasMore = false;
      }
    }
  }

  void searchStoreProducts() async {
    loading = true;
    showUptoTopButton = false;
    var query = {"limit": 12, "page": page, "keyWord": searchController.text};
    query.removeWhere((key, value) => value == 0);
    dynamic searchStoreProducts = await StoreApi().searchStoreProducts(query);
    loading = false;
    setState(() {});
    if (searchStoreProducts != null) {
      dynamic response = Map<String, dynamic>.from(searchStoreProducts);
      if (response["success"]) {
        products = products + response["data"];
      }
      pagination = response["pagination"];
      if (pagination["pageCount"] > page) {
        hasMore = true;
      } else {
        hasMore = false;
      }
    }
  }

  void scrollHandler() {
    scrollController.addListener(() {
      if (scrollController.offset >= 300) {
        showUptoTopButton = true;
      } else {
        showUptoTopButton = false;
      }
      setState(() {});
    });
    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent ==
                scrollController.offset &&
            hasMore) {
          page++;
          setState(() {});
          if (showSearchBar) {
            searchStoreProducts();
          } else {
            getStoreProducts();
          }
        }
      },
    );
  }

  void getStoreCategoryList() async {
    dynamic getStoreCategoryList = await StoreApi().getStoreCategoryList();
    if (getStoreCategoryList != null) {
      dynamic response = Map<String, dynamic>.from(getStoreCategoryList);
      if (response["success"]) {
        categories = response["data"];
        setState(() {});
      }
    }
  }

  void handleCategoryTitle() {
    int wordLength = 10;
    List filteredList = categories
        .where((e) => selectedIndex.contains(categories.indexOf(e)))
        .toList();
    bool isAllSelected = filteredList.any((element) => element["sub"] == 0);
    if (isAllSelected) {
      categoryTitle = "Ангилал";
    } else {
      String name = filteredList[0]["name"];
      int plusNumber = filteredList.length - 1;
      if (filteredList.length == 1) {
        if (name.length > wordLength) {
          categoryTitle = "${name.substring(0, wordLength)}...";
        } else {
          categoryTitle = name;
        }
      } else if (name.length < wordLength) {
        categoryTitle = "$name... ${plusNumber != 0 ? "+$plusNumber" : ""}";
      } else {
        categoryTitle =
            "${name.substring(0, wordLength)}... ${plusNumber != 0 ? "+$plusNumber" : ""}";
      }
    }
    setState(() {});
  }

  void handleSortTitle(String selectedSortName) {
    int wordLength = 10;
    if (selectedSortName.length < wordLength) {
      sortTitle = selectedSortName;
    } else {
      sortTitle = "${selectedSortName.substring(0, wordLength)}...";
    }
    setState(() {});
  }

  void showCategoryBottomSheet() {
    Get.bottomSheet(
      StatefulBuilder(builder: (context, setState) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Ангилал",
                      style: TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(Icons.close_rounded),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 7,
                      color: MyColors.fadedGrey,
                    );
                  },
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    var item = categories[index];
                    var sub = item["sub"];
                    return CustomInkWell(
                      borderRadius: BorderRadius.zero,
                      onTap: () {
                        if (index != 0 && selectedIndex.contains(0)) {
                          selectedIndex.remove(0);
                        }
                        if (index == 0 && !selectedIndex.contains(0)) {
                          selectedIndex.clear();
                        }
                        if (selectedIndex.contains(sub)) {
                          selectedIndex.remove(sub);
                        } else {
                          selectedIndex.add(sub);
                        }
                        List filteredList = categories
                            .where((e) =>
                                selectedIndex.contains(categories.indexOf(e)))
                            .toList();
                        totalCount = 0;
                        for (var element in filteredList) {
                          String count = element["count"].toString();
                          totalCount += int.parse(count);
                        }
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: selectedIndex.contains(sub),
                            onChanged: (val) {},
                            activeColor: MyColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Text(item["name"]),
                          Expanded(
                            child: Text(
                              item["count"].toString(),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          const SizedBox(width: 16)
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: Get.height * .04),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomButton(
                    isActive: selectedIndex.isNotEmpty,
                    onPressed: () {
                      page = 1;
                      products.clear();
                      setState(() {});
                      Get.back();
                      getStoreProducts();
                      handleCategoryTitle();
                    },
                    text: "Хайх ($totalCount)",
                  ),
                ),
              ),
              const SizedBox(height: 16)
            ],
          ),
        );
      }),
      backgroundColor: MyColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
    );
  }

  void showSortBottomSheet() {
    Get.bottomSheet(
      StatefulBuilder(builder: (context, setState) {
        return FractionallySizedBox(
          heightFactor: .5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Эрэмбэлэх",
                      style: TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(Icons.close_rounded),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 7,
                      color: MyColors.fadedGrey,
                    );
                  },
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: sortValues.length,
                  itemBuilder: (context, index) {
                    var item = sortValues[index];
                    return CustomInkWell(
                      borderRadius: BorderRadius.zero,
                      onTap: () {
                        if (sort != item) {
                          sort = item;
                          page = 1;
                          products.clear();
                          setState(() {});
                          Get.back();
                          handleSortTitle(item["name"]);
                          getStoreProducts();
                        } else {
                          sort = {};
                          page = 1;
                          products.clear();
                          setState(() {});
                          Get.back();
                          handleSortTitle("Эрэмбэлэх");
                          getStoreProducts();
                        }
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: sortValues.indexOf(sort) == index,
                            onChanged: (val) {},
                            activeColor: MyColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Text(item["name"]),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Icon(item["icon"])],
                            ),
                          ),
                          const SizedBox(width: 16)
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: Get.height * .04),
            ],
          ),
        );
      }),
      backgroundColor: MyColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
    );
  }

  void showOptions(Map item) {
    String text = item["visibility"] == 1 ? "Идэвхгүй" : "Идэвхтэй";

    Get.bottomSheet(
      SizedBox(
        height: Get.height * .3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(width: Get.width * .04),
                  Expanded(
                    child: Text(
                      item["name"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close_rounded),
                  ),
                  SizedBox(width: Get.width * .01),
                ],
              ),
              _listItem(() {
                Get.toNamed(
                  storeEditProductScreenRoute,
                  arguments: {"id": item["id"]},
                );
              }, IconlyLight.edit, "Барааны мэдээлэл засах"),
              _listItem(() {
                showIdleDialog(item);
              }, item["visibility"] == 0 ? IconlyLight.show : IconlyLight.hide,
                  "$text болгох"),
              _listItem(() {
                showAvailableDialog(item);
              }, IconlyLight.document, "Үлдэгдэл өөрчлөх"),
              _listItem(() {
                showDeleteDialog(item);
              }, IconlyLight.delete, "Устгах")
            ],
          ),
        ),
      ),
      backgroundColor: MyColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
    );
  }

  void showIdleDialog(item) {
    bool visible = item["visibility"] == 1;
    String text = visible ? "идэвхгүй" : "идэвхтэй";
    showMyCustomDialog(true, ActionType.warning,
        "Та ${item["name"]} барааг $text болгохдоо итгэлтэй байна уу?",
        () async {
      Get.back();
      CustomDialogs().showLoadingDialog();
      var body = {"visibility": !visible};
      dynamic updateProductInfo =
          await StoreApi().updateProductInfo(item["id"], body);
      Get.back();
      if (updateProductInfo != null) {
        dynamic response = Map<String, dynamic>.from(updateProductInfo);
        if (response["success"]) {
          int index = products.indexOf(item);
          products[index]["visibility"] = !visible ? 1 : 0;
          setState(() {});
          Get.back();
          customSnackbar(ActionType.success, "Амжилттай засагдлаа", 2);
        }
      } else {
        customSnackbar(ActionType.success, "Алдаа гарлаа", 2);
      }
    }, Container());
  }

  void showAvailableDialog(item) {
    availableController.text = item["available"].toString();
    setState(() {});
    showGeneralDialog(
      context: Get.context!,
      barrierLabel: "",
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.bounceInOut.transform(a1.value);
        return WillPopScope(
          onWillPop: () async => true,
          child: Transform.scale(
            scale: curve,
            child: Center(
              child: Container(
                width: Get.width,
                margin: EdgeInsets.all(Get.width * .09),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(
                  right: Get.width * .09,
                  left: Get.width * .09,
                  top: Get.height * .04,
                  bottom: Get.height * .03,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        IconlyBold.editSquare,
                        size: Get.width * .15,
                        color: Colors.amber,
                      ),
                      SizedBox(height: Get.height * .02),
                      Text(
                        "${item["name"]} барааны үлдэгдэл өөрчлөх",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Get.height * .02),
                      Column(
                        children: [
                          SizedBox(
                            width: Get.width * .3,
                            child: CustomTextField(
                              autoFocus: true,
                              maxLength: 8,
                              keyboardType: TextInputType.number,
                              controller: availableController,
                            ),
                          ),
                          SizedBox(height: Get.height * .04),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                  child: CustomButton(
                                onPressed: Get.back,
                                bgColor: Colors.white,
                                text: "Хаах",
                                elevation: 0,
                                textColor: Colors.black,
                              )),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomButton(
                                  elevation: 0,
                                  bgColor: Colors.amber,
                                  text: "Өөрчлөх",
                                  onPressed: () async {
                                    Get.back();
                                    CustomDialogs().showLoadingDialog();
                                    var body = {
                                      "available": availableController.text
                                    };
                                    dynamic updateProductInfo = await StoreApi()
                                        .updateProductInfo(item["id"], body);
                                    Get.back();
                                    if (updateProductInfo != null) {
                                      dynamic response =
                                          Map<String, dynamic>.from(
                                              updateProductInfo);
                                      if (response["success"]) {
                                        int index = products.indexOf(item);
                                        products[index]["available"] =
                                            int.parse(availableController.text);
                                        setState(() {});
                                        Get.back();
                                        customSnackbar(ActionType.success,
                                            "Амжилттай засагдлаа", 2);
                                      }
                                    } else {
                                      customSnackbar(ActionType.success,
                                          "Алдаа гарлаа", 2);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showDeleteDialog(item) {
    showMyCustomDialog(true, ActionType.warning,
        "Та ${item["name"]} барааг устгахдаа итгэлтэй байна уу?", () async {
      Get.back();
      CustomDialogs().showLoadingDialog();
      dynamic deleteProduct = await StoreApi().deleteProduct(item["id"]);
      Get.back();
      if (deleteProduct != null) {
        dynamic response = Map<String, dynamic>.from(deleteProduct);
        if (response["success"]) {
          int index = products.indexOf(item);
          products.removeAt(index);
          setState(() {});
          Get.back();
          customSnackbar(ActionType.success, "Амжилттай устгалаа", 2);
        }
      } else {
        customSnackbar(ActionType.success, "Алдаа гарлаа", 2);
      }
    }, Container());
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      actionWidth: showSearchBar ? Get.width * .04 : 56,
      customLeading: _customLeading(),
      customTitle: _customTitle(),
      customActions: _customActions(),
      tabBar: _tabBar(),
      body: _body(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 1000),
        opacity: showUptoTopButton ? 1.0 : 0.0,
        child: FloatingActionButton.extended(
          onPressed: scrollToTop,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          label: const Text("Дээш буцах", style: TextStyle(fontSize: 12)),
          icon: const Icon(
            IconlyLight.arrow_up,
            size: 16,
          ),
        ),
      ),
    );
  }

  Widget _customActions() {
    return showSearchBar
        ? Container()
        : IconButton(
            onPressed: () {
              products.clear();
              showSearchBar = true;
              setState(() {});
            },
            icon: const Icon(
              IconlyLight.search,
              color: Colors.black,
              size: 20,
            ),
          );
  }

  PreferredSize _tabBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(showSearchBar ? 0 : Get.height * .07),
      child: showSearchBar
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: Get.width * .04),
                  _button(categoryTitle, () {
                    showCategoryBottomSheet();
                  }, IconlyLight.category),
                  SizedBox(width: Get.width * .02),
                  _button(sortTitle, () {
                    showSortBottomSheet();
                  }, IconlyLight.filter_2),
                  SizedBox(width: Get.width * .04),
                ],
              ),
            ),
    );
  }

  Widget _customTitle() {
    return showSearchBar
        ? _search()
        : const Text(
            "Бараа засварлах",
            style: TextStyle(color: Colors.black, fontSize: 16),
          );
  }

  Widget _customLeading() {
    return CustomInkWell(
      onTap: showSearchBar
          ? () {
              showSearchBar = false;
              categoryTitle = "Ангилал";
              sortTitle = "Эрэмбэлэх";
              selectedIndex = [];
              sort = {};
              page = 1;
              searchController.clear();
              products.clear();
              setState(() {});
              getStoreProducts();
            }
          : Get.back,
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Icon(
          showSearchBar ? Icons.close_rounded : IconlyLight.arrow_left,
          color: MyColors.black,
          size: 20,
        ),
      ),
    );
  }

  Widget _body() {
    return products.isNotEmpty
        ? ListView.separated(
            separatorBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                height: Get.height * .008,
                decoration: BoxDecoration(color: MyColors.fadedGrey),
              );
            },
            padding: const EdgeInsets.only(top: 12),
            physics: const BouncingScrollPhysics(),
            itemCount: hasMore ? products.length + 1 : products.length,
            controller: scrollController,
            itemBuilder: (context, index) {
              if (index < products.length) {
                var item = products[index];
                return Container(
                  height: Get.height * .08,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: Get.width * .04),
                      Stack(
                        children: [
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: Get.width * 0.15,
                                maxHeight: Get.width * 0.15,
                              ),
                              child: Stack(
                                children: [
                                  customImage(
                                    Get.width * 0.15,
                                    "${URL.AWS}/users/${item["id"]}/small/1.png",
                                    isCircle: true,
                                  ),
                                  item["visibility"] == 0
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.visibility_off,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              )),
                        ],
                      ),
                      SizedBox(width: Get.width * .04),
                      SizedBox(
                        width: Get.width * .55,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: item["name"],
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Үлдэгдэл: ${item["available"]}",
                              style: const TextStyle(
                                  color: MyColors.gray, fontSize: 12),
                            ),
                            Text(
                                "Үнэ: ${convertToCurrencyFormat(item["price"])}"),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => showOptions(item),
                            icon: const Icon(
                              IconlyLight.edit_square,
                              size: 20,
                            ),
                          )
                        ],
                      )),
                      SizedBox(width: Get.width * .04),
                    ],
                  ),
                );
              } else if (hasMore) {
                return storeProductsEditScreenShimmer();
              } else {
                return Container();
              }
            },
          )
        : loading
            ? listShimmerWidget()
            : customEmptyWidget(
                showSearchBar ? "Хайх үгээ оруулна уу" : "Хайлт илэрцгүй байна",
              );
  }

  Widget _button(String text, VoidCallback onPressed, IconData icon) {
    return Expanded(
      child: CustomInkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1,
              color: MyColors.background,
            ),
          ),
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                icon,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _search() {
    return CustomTextField(
      autoFocus: true,
      leadingIcon: IconlyLight.search,
      hintText: "Бүтээгдэхүүн хайх...",
      controller: searchController,
      onChanged: _onTypingFinished,
    );
  }

  Widget _listItem(dynamic onTap, IconData icon, String text) {
    return Expanded(
      child: CustomInkWell(
        borderRadius: BorderRadius.zero,
        onTap: onTap,
        child: Center(
          child: Row(
            children: [
              SizedBox(width: Get.width * .04),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: MyColors.fadedGrey, shape: BoxShape.circle),
                child: Icon(
                  icon,
                  size: 18,
                ),
              ),
              SizedBox(width: Get.width * .03),
              CustomText(text: text),
            ],
          ),
        ),
      ),
    );
  }
}

Widget storeProductsEditScreenShimmer() {
  return Container(
    height: Get.height * .08,
    padding: const EdgeInsets.symmetric(vertical: 4),
    margin: const EdgeInsets.only(bottom: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: Get.width * .04),
        Stack(
          children: [
            ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Get.width * 0.15,
                  maxHeight: Get.width * 0.15,
                ),
                child: CustomShimmer(
                  width: Get.width * .15,
                  height: Get.width * .15,
                  borderRadius: 50,
                )),
          ],
        ),
        SizedBox(width: Get.width * .04),
        SizedBox(
          width: Get.width * .7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomShimmer(width: Get.width * .7, height: 16),
              CustomShimmer(width: Get.width * .7, height: 16),
              CustomShimmer(width: Get.width * .7, height: 16),
            ],
          ),
        ),
        SizedBox(width: Get.width * .04),
      ],
    ),
  );
}
