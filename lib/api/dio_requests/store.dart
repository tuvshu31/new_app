import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/api/dio_instance.dart';
import 'package:Erdenet24/api/restapi_helper.dart';

class StoreApi {
  int storeId = RestApiHelper.getUserId();
  static final StoreApi _singleton = StoreApi._internal();
  factory StoreApi() => _singleton;
  StoreApi._internal();

  //Дэлгүүрийн товч мэдээллийг авах
  Future getStoreInfo() async {
    return DioClient()
        .sendRequest('getStoreInfo?id=$storeId', Method.post, [], {});
  }

  //Дэлгүүрийн ангиллуудыг авах
  Future getStoreCategoryList() async {
    return DioClient().sendRequest(
        'getStoreCategoryList?storeId=$storeId', Method.post, [], {});
  }

  //Дэлгүүрийн бүх бараануудыг авах
  Future getStoreProducts(dynamic query) async {
    return DioClient()
        .sendRequest('getStoreProducts?store=$storeId', Method.post, [], query);
  }

  //Дэлгүүрийн бараа хайх
  Future searchStoreProducts(dynamic query) async {
    return DioClient().sendRequest(
        'searchStoreProducts?store=$storeId', Method.post, [], query);
  }

  //Дэлгүүрээ нээх, хаах
  Future openAndCloseStore(int isOpen) async {
    return DioClient().sendRequest(
        'openAndCloseStore?storeId=$storeId&isOpen=$isOpen',
        Method.post, [], {});
  }

  //Шинэ бараа нэмэх
  Future addProduct(dynamic body) async {
    return DioClient()
        .sendRequest('addProduct?storeId=$storeId', Method.post, body, {});
  }

  //Шинэ барааны зураг нэмэх
  Future addProductPhoto(int productId, List images) async {
    return DioClient()
        .sendFile('addProductPhoto?productId=$productId', Method.post, images);
  }

  //Барааны мэдээлэл засах
  Future updateProductInfo(int productId, dynamic body) async {
    return DioClient().sendRequest(
        'updateProductInfo?productId=$productId', Method.post, body, {});
  }

  //Бараа устгах
  Future deleteProduct(int productId) async {
    return DioClient()
        .sendRequest('deleteProduct?productId=$productId', Method.post, [], {});
  }

  //Тухайн нэг барааны мэдээллийг авах
  Future getProductInfo(int productId) async {
    return DioClient().sendRequest(
        'getProductInfo?productId=$productId', Method.post, [], {});
  }

  //Тухайн дэлгүүрийн захиалгуудыг авах
  Future getStoreOrders(dynamic query) async {
    return DioClient()
        .sendRequest('getStoreOrders?storeId=$storeId', Method.post, [], query);
  }

  //Захиалгын барааны дэлгэрэнгүй мэдээллүүдийг авах
  Future getStoreOrderDetails(int orderId) async {
    return DioClient().sendRequest(
        'getStoreOrderDetails?orderId=$orderId', Method.post, [], {});
  }

  //Захиалгын барааны дэлгэрэнгүй мэдээллүүдийг авах
  Future updateOrderStatus(int orderId, dynamic query) async {
    return DioClient().sendRequest(
        'updateOrderStatus?orderId=$orderId', Method.post, [], query);
  }

  //Тухайн дэлгүүрийн ангилал дах дэд ангиллуудыг авах
  Future getStoreRelatedCategory() async {
    return DioClient().sendRequest(
        'getStoreRelatedCategory?storeId=$storeId', Method.post, [], {});
  }

  //Тухайн захиалгыг бэлдэж эхлэх
  Future startPreparingOrder(int orderId, int prepDuration) async {
    return DioClient().sendRequest(
        'startPreparingOrder?orderId=$orderId&prepDuration=$prepDuration',
        Method.post, [], {});
  }

  //Тухайн захиалгыг хүргэлтэнд гаргах
  Future setToDelivery(int orderId) async {
    return DioClient()
        .sendRequest('setToDelivery?orderId=$orderId', Method.post, [], {});
  }

  //Шинэ захиалга ирсэн үгүйг шалгах
  Future checkStoreNewOrders() async {
    return DioClient().sendRequest(
        'checkStoreNewOrders?storeId=$storeId', Method.post, [], {});
  }
}
