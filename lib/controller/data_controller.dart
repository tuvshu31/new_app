import 'package:get/get.dart';
import 'package:Erdenet24/api/dio_requests/user.dart';

class DataController extends GetxController {
  List categories = [].obs;

  void getMainCategories() async {
    dynamic getMainCategories = await UserApi().getMainCategories();
    dynamic response = Map<String, dynamic>.from(getMainCategories);
    if (response["success"]) {
      categories = response["data"];
    }
  }
}
