import 'package:get/get.dart';
import 'package:Erdenet24/api/dio_requests.dart';

class ProductController extends GetxController {
  var page = 1.obs;
  var data = [].obs;
  var total = 0.obs;
  var search = 0.obs;
  var searchText = "".obs;
  var storeName = "".obs;
  var storeId = 0.obs;
  var typeId = 1.obs;
  var categoryId = 0.obs;
  var hasMore = true.obs;
  var loading = false.obs;
  var onScrollShowHide = false.obs;

  void changeTab(int index) {
    data.clear();
    page.value = 1;
    hasMore.value = true;
    categoryId.value = index;
    // callProducts();
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
