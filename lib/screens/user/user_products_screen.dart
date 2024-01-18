import 'dart:async';
import 'dart:developer';
import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class UserProductsScreen extends StatefulWidget {
  const UserProductsScreen({super.key});

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  final _arguments = Get.arguments;
  List products = [];
  bool loading = false;
  int page = 1;
  bool hasMore = false;
  int totalCount = 0;
  Map pagination = {};
  List<int> selectedIndex = [];
  bool showUptoTopButton = false;
  bool searching = false;
  String categoryTitle = "Ангилал";
  String sortTitle = "Эрэмбэлэх";
  bool showSearchBar = false;
  Map sort = {};
  bool catLoading = false;
  List categories = [];
  List<Map<dynamic, dynamic>> sortValues = [
    {"name": "Үнэ өсөхөөр", "icon": IconlyLight.arrow_up, "sort": "price"},
    {"name": "Үнэ буурахаар", "icon": IconlyLight.arrow_down, "sort": "-price"},
    {"name": "Хямдралтай нь эхэндээ", "icon": Icons.tag, "sort": "salePercent"},
  ];
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    scrollHandler();
    getUserProducts();
    getUserStoreCategories();
  }

  void getUserProducts() async {
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
      "store": _arguments["id"],
      "limit": 15,
      "page": page,
      "typeId": typeId,
      "sort": sort.isEmpty ? 0 : sort["sort"]
    };
    query.removeWhere((key, value) => value == 0);
    dynamic getUserProducts = await UserApi().getUserProducts(query);
    loading = false;
    if (getUserProducts != null) {
      dynamic response = Map<String, dynamic>.from(getUserProducts);
      if (response["success"]) {
        products = products + response["data"];
        pagination = response["pagination"];
        if (pagination["pageCount"] > page) {
          hasMore = true;
        } else {
          hasMore = false;
        }
      }
    }
    setState(() {});
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

  void getUserStoreCategories() async {
    catLoading = true;
    dynamic getUserStoreCategories =
        await UserApi().getUserStoreCategories(_arguments["id"]);
    catLoading = false;
    if (getUserStoreCategories != null) {
      dynamic response = Map<String, dynamic>.from(getUserStoreCategories);
      if (response["success"]) {
        categories = response["data"];
      }
    }
    setState(() {});
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
            searchUserProducts();
          } else {
            getUserProducts();
          }
        }
      },
    );
  }

  void searchUserProducts() async {
    loading = true;
    setState(() {});
    showUptoTopButton = false;
    var query = {"limit": 12, "page": page, "keyWord": searchController.text};
    query.removeWhere((key, value) => value == 0);
    dynamic searchUserProducts =
        await UserApi().searchUserProducts(_arguments["id"], query);
    loading = false;
    setState(() {});
    if (searchUserProducts != null) {
      dynamic response = Map<String, dynamic>.from(searchUserProducts);
      setState(() {
        if (response["success"]) {
          products = products + response["data"];
          log(products.toString());
        }
        pagination = response["pagination"];
        if (pagination["pageCount"] > page) {
          hasMore = true;
        } else {
          hasMore = false;
        }
      });
    }
  }

  void scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
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
                      "Ангилал сонгох",
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
                      getUserProducts();
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
          heightFactor: .35,
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
                          getUserProducts();
                        } else {
                          sort = {};
                          page = 1;
                          products.clear();
                          setState(() {});
                          Get.back();
                          handleSortTitle("Эрэмбэлэх");
                          getUserProducts();
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

  Timer? _debounceTimer;
  void _onTypingFinished(String text) {
    searching = true;
    setState(() {});
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      log('Typing finished: $text');
      page = 1;
      products.clear();
      searching = false;
      setState(() {});
      if (text.isNotEmpty) {
        searchUserProducts();
      }
    });
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
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _arguments["title"],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              _arguments["isOpen"] == false
                  ? const Text(
                      "Хаалттай",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        // fontStyle: FontStyle.italic,
                      ),
                    )
                  : Container(),
            ],
          );
  }

  Widget _search() {
    return Container(
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
                hintText: "Бүтээгдэхүүн хайх...",
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
    );
  }

  Widget _body() {
    return loading && products.isEmpty
        ? productsLoadingWidget()
        : !loading && products.isEmpty
            ? customEmptyWidget("Хайлт илэрцгүй байна")
            : RefreshIndicator(
                color: MyColors.primary,
                onRefresh: () async {
                  products.clear();
                  page = 1;
                  await Future.delayed(const Duration(milliseconds: 600));
                  setState(() {});
                  getUserProducts();
                },
                child: GridView.builder(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: hasMore ? products.length + 3 : products.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    if (index < products.length) {
                      var item = products[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomInkWell(
                            onTap: () => Get.toNamed(
                              userProductDetailScreenRoute,
                              arguments: {
                                "id": item["id"],
                                "store": item["store"],
                                "storeName": _arguments["title"],
                              },
                            ),
                            child: Hero(
                              transitionOnUserGestures: true,
                              tag: item["id"],
                              child: Stack(
                                children: [
                                  customImage(Get.width * .3, item["image"]),
                                  item["salePercent"] > 0
                                      ? Positioned(
                                          right: 10,
                                          top: 5,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "-${item["salePercent"]}%",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: Get.width * .3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      convertToCurrencyFormat(item['price']),
                                    ),
                                    item["salePercent"] > 0
                                        ? Text(
                                            convertToCurrencyFormat(
                                                item['oldPrice']),
                                            style: const TextStyle(
                                              color: MyColors.gray,
                                              fontSize: 10,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item["name"] ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (hasMore) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomShimmer(
                              width: Get.width * .3, height: Get.width * .3),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: Get.width * .3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomShimmer(
                                    width: Get.width * .2, height: 16),
                                const SizedBox(height: 4),
                                CustomShimmer(width: Get.width * .2, height: 16)
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
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
              getUserProducts();
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

  Widget _button(String text, VoidCallback onPressed, IconData icon) {
    return Expanded(
      child: CustomInkWell(
        onTap: onPressed,
        child: Container(
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
            children: [
              Icon(
                icon,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
