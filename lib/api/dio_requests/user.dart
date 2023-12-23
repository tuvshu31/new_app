import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/api/dio_instance.dart';
import 'package:Erdenet24/api/restapi_helper.dart';

int userId = RestApiHelper.getUserId();

class UserApi {
  static final UserApi _singleton = UserApi._internal();
  factory UserApi() => _singleton;
  UserApi._internal();

  //Нэг удаагийн код үүсгэх
  Future sendAuthCode(String phone) async {
    return DioClient()
        .sendRequest('sendAuthCode?phone=$phone', Method.post, [], {});
  }

  //Хэрэглэгчийн role-г шалгах
  Future checkUserRole(String phone) async {
    return DioClient()
        .sendRequest('checkUserRole?phone=$phone', Method.post, [], {});
  }

  //Хэрэглэгчийн үндсэн ангиллуудыг авах
  Future getMainCategories() async {
    return DioClient().sendRequest('getMainCategories', Method.post, [], {});
  }

  //Хэрэглэгчийн тухайн ангилал дахь дэлгүүрүүдийн жагсаалтыг авах
  Future getStoreList(int id) async {
    return DioClient()
        .sendRequest('getStoreList?category=$id', Method.post, [], {});
  }

  //Хэрэглэгчийн хадгалсан бараануудыг авах
  Future getUserSavedProducts(dynamic query) async {
    return DioClient()
        .sendRequest('getUserSavedProducts?id=$userId', Method.post, [], query);
  }

  //Хэрэглэгч бараа хадгалах
  Future addToSaved(int productId, int storeId) async {
    return DioClient().sendRequest(
        'addToSaved?id=$userId&storeId=$storeId&productId=$productId',
        Method.post, [], {});
  }

  //Хэрэглэгчийн хадгалсан барааг устгах
  Future deleteUserSavedProduct(int productId) async {
    return DioClient().sendRequest(
        'deleteUserSavedProduct?id=$userId&productId=$productId',
        Method.post, [], {});
  }

  //Хэрэглэгчийн сагсан дахь бараануудыг авах
  Future getUserCartProducts() async {
    return DioClient()
        .sendRequest('getUserCartProducts?id=$userId', Method.post, [], {});
  }

  //Хэрэглэгч сагсандаа бараа нэмэх
  Future addToCart(int productId, int storeId, {int quantity = 1}) async {
    return DioClient().sendRequest(
        'addToCart?id=$userId&productId=$productId&storeId=$storeId&quantity=$quantity',
        Method.post, [], {});
  }

  //Хэрэглэгч сагснаасаа бараа хасах
  Future removeFromCart(int productId, {int quantity = 1}) async {
    return DioClient().sendRequest(
        'removeFromCart?id=$userId&productId=$productId&quantity=$quantity',
        Method.post, [], {});
  }

  //Хэрэглэгч сагснаасаа бараа устгах
  Future deleteFromCart(int productId) async {
    return DioClient().sendRequest(
        'deleteFromCart?id=$userId&productId=$productId', Method.post, [], {});
  }

  //Хэрэглэгчийн сагсыг хоослох
  Future emptyTheCart() async {
    return DioClient()
        .sendRequest('emptyTheCart?id=$userId', Method.post, [], {});
  }

  //Хэрэглэгчийн захиалгуудыг авах
  Future getUserOrders(dynamic query) async {
    return DioClient()
        .sendRequest('getUserOrders?id=$userId', Method.post, [], query);
  }

  //Сонгосон дэлгүүрийн бараануудыг авах
  Future getUserProducts(dynamic query) async {
    return DioClient().sendRequest('getUserProducts', Method.post, [], query);
  }

  //Сонгосон дэлгүүрийн ангиллууддах бараануудын тоог авах
  Future getUserStoreCategories(int storeId) async {
    return DioClient().sendRequest(
        'getUserStoreCategories?storeId=$storeId', Method.post, [], {});
  }

  //Сонгосон барааны дэлгэрэнгүй мэдээллийг авах
  Future getProductDetails(int id) async {
    return DioClient()
        .sendRequest('getProductDetails?id=$id', Method.post, [], {});
  }

  //Сонгосон барааны авах боломжтой эсэх мэдээллийг авах
  Future getProductAvailableInfo(int storeId, int productId) async {
    return DioClient().sendRequest(
        'getProductAvailableInfo?storeId=$storeId&productId=$productId&userId=$userId',
        Method.post, [], {});
  }

  //Сонгосон дэлгүүрийн бараануудыг шүүх
  Future searchUserProducts(int storeId, dynamic query) async {
    return DioClient().sendRequest(
        'searchUserProducts?store=$storeId', Method.post, [], query);
  }

  //Хэрэглэгчийн хаягийг авах
  Future getUserAddress() async {
    return DioClient()
        .sendRequest('getUserAddress?userId=$userId', Method.post, [], {});
  }

  //Бүх байршилуудыг датаг авах
  Future getAllLocations() async {
    return DioClient().sendRequest('getAllLocations', Method.post, [], {});
  }

  //Шинэ захиалга үүсгэх
  Future createNewOrder(dynamic body) async {
    return DioClient()
        .sendRequest('createNewOrder?userId=$userId', Method.post, body, {});
  }

  //Захиалгын дэлгэрэнгүй мэдээллийг авах
  Future getUserOrderDetails(int orderId) async {
    return DioClient().sendRequest(
        'getUserOrderDetails?orderId=$orderId', Method.post, [], {});
  }

  //Qpay-н нэхэмжлэх үүсгэх
  Future createQpayInvoice(dynamic body) async {
    return DioClient().sendRequest('createQpayInvoice', Method.post, body, {});
  }

  //Хэрэглэгчийн socketId-г хадгалах
  Future saveSocketId(dynamic body) async {
    return DioClient().sendRequest('saveSocketId', Method.post, body, {});
  }

  //Бүх дэлгүүрүүдээс хайлт хийх
  Future searchUserAllProducts(String keyWord) async {
    return DioClient().sendRequest(
        'searchUserAllProducts?keyWord=$keyWord', Method.post, [], {});
  }

  //Сагсаа хоослоод нэмэх
  Future emptyAndAddToCart(int productId, int storeId,
      {int quantity = 1}) async {
    return DioClient().sendRequest(
        'emptyAndAddToCart?id=$userId&productId=$productId&storeId=$storeId&quantity=$quantity',
        Method.post, [], {});
  }

  //Хэрэглэгчийн хандаж буй төхөөрөмжийг шалгах
  Future checkUserDeviceInfo(
    String role,
    String device,
  ) async {
    return DioClient().sendRequest(
        'checkUserDeviceInfo?id=$userId&role=$role&device=$device',
        Method.post, [], {});
  }

  //Хэрэглэгчийн хувийн мэдээллийг авах
  Future getUserInfoDetails() async {
    return DioClient()
        .sendRequest('getUserInfoDetails?userId=$userId', Method.post, [], {});
  }
}
