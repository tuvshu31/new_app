import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/screens/user/user_products_screen.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:Erdenet24/api/restapi_helper.dart';
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
  bool isSearching = false;
  bool fetchinSuggestions = false;
  List searchHistory = [];
  List searchSuggestions = [];
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    searchHistory = RestApiHelper.getSearchHistory();
    setState(() {});
  }

  void saveSearchHistory(Map searchedItem) {
    if (searchHistory.any((element) => element["id"] != searchedItem["id"])) {
      searchHistory.add(searchedItem);
    }
    setState(() {});
  }

  void deleteSearchHistory(int index) {
    searchHistory.removeAt(index);
    setState(() {});
  }

  void searchProducts(String text) async {
    fetchinSuggestions = true;
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'GET', Uri.parse('http://3.35.52.56:8000/products/search'));
    request.body = json.encode({"keyWord": text});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var res = json.decode(data);
      searchSuggestions.clear();
      searchSuggestions = res["data"];
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
    fetchinSuggestions = false;
    setState(() {});
  }

  void addToSearchHistory(Map obj) {
    String value = "id";
    if (obj["type"] == "word") {
      value = "name";
    }
    if (searchHistory.any((element) => element[value] == obj[value])) {
      searchHistory.removeWhere((element) => element[value] == obj[value]);
    }
    searchHistory.add(obj);
  }

  void saveAsHistoryAndNavigate(obj) {
    addToSearchHistory(obj);
    Get.to(
      () => UserProductsScreen(
        navType: NavType.none,
        title: "Бүтээгдэхүүн",
        isFromSeachBar: true,
        searchObject: obj,
      ),
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      searchController.clear();
      isSearching = false;
      setState(() {});
    });
  }

  String searchSugestionImageHandler(item) {
    String url = "products";
    if (item["type"] == "store") {
      url = "users";
    }
    return "${URL.AWS}/$url/${item["id"]}/small/1.png";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.white,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: MyColors.white,
            appBar: AppBar(
              actions: const [SizedBox(width: 24)],
              elevation: 0,
              leadingWidth: 56,
              leading: CustomInkWell(
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
              backgroundColor: MyColors.white,
              centerTitle: true,
              titleSpacing: 0,
              title: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: MyColors.fadedGrey,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 12),
                      child: const Center(
                        child: Icon(
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
                            color: MyColors.grey,
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
                        cursorWidth: 1,
                        onSubmitted: (value) {
                          var item = {
                            "name": value,
                            "type": "word",
                          };
                          saveAsHistoryAndNavigate(item);
                        },
                        onChanged: (value) {
                          searchProducts(value);
                          isSearching = value.isNotEmpty ? true : false;
                          setState(() {});
                        },
                      ),
                    ),
                    isSearching
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();
                              isSearching = false;
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
            ),
            body: isSearching ? _searchSuggestion() : _searchHistory(),
          ),
        ),
      ),
    );
  }

  Widget _searchHistory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const CustomText(text: "Сүүлд хайсан"),
          const SizedBox(height: 12),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                reverse: true,
                shrinkWrap: true,
                itemCount: searchHistory.length,
                itemBuilder: (context, index) {
                  var item = searchHistory[index];
                  return Container(
                    padding: const EdgeInsets.only(top: 6, left: 12, bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: () {
                              saveAsHistoryAndNavigate(item);
                            },
                            child: Row(
                              children: [
                                item["type"] == "word"
                                    ? SizedBox(
                                        width: Get.width * .07,
                                        height: Get.width * .07,
                                        child: const Center(
                                          child: Icon(
                                            IconlyLight.search,
                                            size: 18,
                                            color: MyColors.gray,
                                          ),
                                        ),
                                      )
                                    : CustomImage(
                                        width: Get.width * .07,
                                        height: Get.width * .07,
                                        url: searchSugestionImageHandler(item),
                                      ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  width: Get.width * .7,
                                  child: CustomText(
                                    text: item["name"],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )),
                        GestureDetector(
                          onTap: () {
                            searchHistory.remove(item);
                            setState(() {});
                          },
                          child: const Icon(
                            Icons.close_rounded,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchSuggestion() {
    return fetchinSuggestions && searchSuggestions.isEmpty
        ? const Center(child: CupertinoActivityIndicator())
        : !fetchinSuggestions && searchSuggestions.isEmpty
            ? Container()
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: searchSuggestions.length,
                itemBuilder: (context, index) {
                  var item = searchSuggestions[index];
                  return CustomInkWell(
                    borderRadius: BorderRadius.zero,
                    onTap: () {
                      saveAsHistoryAndNavigate(item);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            IconlyLight.search,
                            size: 16,
                          ),
                          SizedBox(
                              width: Get.width * .7,
                              child: CustomText(
                                text: item["name"],
                                overflow: TextOverflow.ellipsis,
                              )),
                          CustomImage(
                            width: Get.width * .07,
                            height: Get.width * .07,
                            url: searchSugestionImageHandler(item),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
  }
}
