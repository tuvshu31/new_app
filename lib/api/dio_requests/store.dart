import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/api/dio_instance.dart';

class StoreApi {
  static final StoreApi _singleton = StoreApi._internal();
  factory StoreApi() => _singleton;
  StoreApi._internal();

  //Дэлгүүрийн товч мэдээллийг авах
  Future getStoreInfo() async {
    return DioClient().sendRequest('getStoreInfo', Method.post, [], {});
  }

  //Дэлгүүрийн ангиллуудыг авах
  Future getStoreCategoryList() async {
    return DioClient().sendRequest('getStoreCategoryList', Method.post, [], {});
  }

  //Дэлгүүрийн бүх бараануудыг авах
  Future getStoreProducts(dynamic query) async {
    return DioClient().sendRequest('getStoreProducts', Method.post, [], query);
  }

  //Дэлгүүрийн бараа хайх
  Future searchStoreProducts(dynamic query) async {
    return DioClient()
        .sendRequest('searchStoreProducts', Method.post, [], query);
  }

  //Дэлгүүрээ нээх, хаах
  Future openAndCloseStore(int isOpen) async {
    return DioClient()
        .sendRequest('openAndCloseStore?isOpen=$isOpen', Method.post, [], {});
  }

  //Шинэ бараа нэмэх
  Future addProduct(dynamic body) async {
    return DioClient().sendRequest('addProduct', Method.post, body, {});
  }

  //Шинэ барааны зураг нэмэх
  Future addProductPhoto(int productId, List images) async {
    return DioClient()
        .sendFile('addProductPhoto?productId=$productId', Method.post, images);
  }

  //Барааны зураг засах
  Future updateProductPhoto(
      int productId, List oldImages, List newImages) async {
    return DioClient().sendFile(
        'updateProductPhoto?productId=$productId&oldImages=$oldImages',
        Method.post,
        newImages);
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
    return DioClient().sendRequest('getStoreOrders', Method.post, [], query);
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
    return DioClient()
        .sendRequest('getStoreRelatedCategory', Method.post, [], {});
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
    return DioClient().sendRequest('checkStoreNewOrders', Method.post, [], {});
  }

  //Дэлгүүр өөртөө захиалга үүсгэх
  Future storeCreateNewOrder(dynamic body) async {
    return DioClient()
        .sendRequest('storeCreateNewOrder', Method.post, body, {});
  }

  //Дэлгүүр жолооч дуудахын тулд хэрэглэгчийн байршлыг шалгах
  Future storeCheckUserLocation() async {
    return DioClient()
        .sendRequest('storeCheckUserLocation', Method.post, [], {});
  }

  //Дэлгүүр хүргэлтийн төлбөрийг тооцоолох
  Future storeCalculateDeliveryPrice(dynamic body) async {
    return DioClient()
        .sendRequest('storeCalculateDeliveryPrice', Method.post, body, {});
  }
}
