import 'package:get/get.dart';
import 'package:Erdenet24/api/dio_requests.dart';

class ProductController extends GetxController {
  var page = 1.obs;
  var data = [].obs;
  var total = 0.obs;
  var search = 0.obs;
  var searchText = "".obs;
  var storeId = 0.obs;
  var typeId = 1.obs;
  var categoryId = 0.obs;
  var hasMore = true.obs;
  var loading = false.obs;
  var onScrollShowHide = false.obs;

  //Бараануудыг шүүж дуудах
  void callProducts() async {
    loading.value = true;
    var query = {
      "typeId": typeId.value,
      "page": page.value,
      "categoryId": categoryId.value,
      "store": storeId.value,
      "visibility": '1',
      "search": search.value != 0 ? searchText.value : 0,
    };
    query.removeWhere((key, value) => value == 0);
    print(query);
    dynamic products = await RestApi().getProducts(query);
    dynamic p = Map<String, dynamic>.from(products);
    total.value = p["pagination"]["count"];
    if (p["data"].length < p["pagination"]["limit"]) {
      hasMore.value = false;
    }
    data = data + p['data'];
    loading.value = false;
  }

  void changeTab(int index) {
    data.clear();
    page.value = 1;
    hasMore.value = true;
    categoryId.value = index;
    callProducts();
  }

  // static Future<CardItem> getRecentCreatedCard() async {
  //   var res = await RestApi().getCards({
  //     'order': 'most_recent',
  //     'order_up': 1,
  //     'filter': "",
  //     'filter_type': 'all',
  //     'more': false,
  //     'page': 1,
  //     'page_size': 1,
  //     'folder_type': false,
  //     'folder_id': false,
  //   });
  //   dynamic data = Map<String, dynamic>.from(json.decode(res.data));
  //   if (data['cards'] == null) {
  //     return CardItem();
  //   }
  //   return CardItem.fromJson(data['cards'][0]);
  // }
}
