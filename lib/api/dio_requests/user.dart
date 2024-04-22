import 'dart:developer';

import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/api/dio_instance.dart';

class UserApi {
  static final UserApi _singleton = UserApi._internal();
  factory UserApi() => _singleton;
  UserApi._internal();

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
        .sendRequest('getUserSavedProducts', Method.post, [], query);
  }

  //Хэрэглэгч бараа хадгалах
  Future addToSaved(int productId) async {
    return DioClient()
        .sendRequest('addToSaved?productId=$productId', Method.post, [], {});
  }

  //Хэрэглэгчийн хадгалсан барааг устгах
  Future deleteUserSavedProduct(int productId) async {
    return DioClient().sendRequest(
        'deleteUserSavedProduct?productId=$productId', Method.post, [], {});
  }

  //Хэрэглэгчийн сагсан дахь бараануудыг авах
  Future getUserCartProducts() async {
    return DioClient().sendRequest('getUserCartProducts', Method.post, [], {});
  }

  //Хэрэглэгч сагсандаа бараа нэмэх
  Future addToCart(int productId, int storeId, {int quantity = 1}) async {
    return DioClient().sendRequest(
        'addToCart?productId=$productId&storeId=$storeId&quantity=$quantity',
        Method.post, [], {});
  }

  //Хэрэглэгч сагснаасаа бараа хасах
  Future removeFromCart(int productId, {int quantity = 1}) async {
    return DioClient().sendRequest(
        'removeFromCart?productId=$productId&quantity=$quantity',
        Method.post, [], {});
  }

  //Хэрэглэгч сагснаасаа бараа устгах
  Future deleteFromCart(int productId) async {
    return DioClient().sendRequest(
        'deleteFromCart?productId=$productId', Method.post, [], {});
  }

  //Хэрэглэгчийн сагсыг хоослох
  Future emptyTheCart() async {
    return DioClient().sendRequest('emptyTheCart', Method.post, [], {});
  }

  //Хэрэглэгчийн захиалгуудыг авах
  Future getUserOrders(dynamic query) async {
    return DioClient().sendRequest('getUserOrders', Method.post, [], query);
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
        'getProductAvailableInfo?storeId=$storeId&productId=$productId',
        Method.post, [], {});
  }

  //Сонгосон дэлгүүрийн бараануудыг шүүх
  Future searchUserProducts(int storeId, dynamic query) async {
    return DioClient().sendRequest(
        'searchUserProducts?store=$storeId', Method.post, [], query);
  }

  //Хэрэглэгчийн хаягийг авах
  Future getUserAddress() async {
    return DioClient().sendRequest('getUserAddress', Method.post, [], {});
  }

  //Бүх байршилуудыг датаг авах
  Future getAllLocations() async {
    return DioClient().sendRequest('getAllLocations', Method.post, [], {});
  }

  //Шинэ захиалга үүсгэх
  Future createNewOrder(dynamic body) async {
    return DioClient().sendRequest('createNewOrder', Method.post, body, {});
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
  Future saveSocketIdNew(dynamic body) async {
    return DioClient().sendRequest('saveSocketIdNew', Method.post, body, {});
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
        'emptyAndAddToCart?productId=$productId&storeId=$storeId&quantity=$quantity',
        Method.post, [], {});
  }

  //Хэрэглэгчийн хандаж буй төхөөрөмжийг шалгах
  Future checkUserDeviceInfo(
    String role,
    String device,
  ) async {
    return DioClient().sendRequest(
        'checkUserDeviceInfo?role=$role&device=$device', Method.post, [], {});
  }

  //Хэрэглэгчийн хувийн мэдээллийг авах
  Future getUserInfoDetails() async {
    return DioClient().sendRequest('getUserInfoDetails', Method.post, [], {});
  }

  //Хэрэглэгчийн утасны дугаар өөрчлөх үед утасны дугаар шалгаад баталгаажуулах код явуулах
  Future checkPhoneAndSendOTP(String phone) async {
    return DioClient()
        .sendRequest('checkPhoneAndSendOTP?phone=$phone', Method.post, [], {});
  }

  //QR code унших үед дэлгүүрийн мэдээллийг авах
  Future getStoreInfo(int storeId) async {
    return DioClient()
        .sendRequest('getStoreInfo?id=$storeId', Method.post, [], {});
  }

  //Хэрэглэгчийн утасны дугаарыг өөрчлөх
  Future updateUserPhoneNumber(String phone) async {
    return DioClient()
        .sendRequest('updateUserPhoneNumber?phone=$phone', Method.post, [], {});
  }

  //Хэрэглэгчийн байршлын мэдээллийг өөрчлөх
  Future updateUserAddress(dynamic body) async {
    return DioClient().sendRequest('updateUserAddress', Method.post, body, {});
  }

  //Хэрэглэгчийн тусламж хэсгийн мэдээллүүдийг дуудах
  Future getUserHelpContent() async {
    return DioClient().sendRequest('getUserHelpContent', Method.post, [], {});
  }

  //ХАйлт хийх үед дэлгүүрийн дэлгүүрийн мэдээллийг дуудах
  Future getStoreDetailsInfo(dynamic body) async {
    return DioClient()
        .sendRequest('getStoreDetailsInfo', Method.post, body, {});
  }

  //Хэрэглэгчийн firebase token-г хадгалж авах
  Future saveUserTokenNew(dynamic body) async {
    return DioClient().sendRequest('saveUserTokenNew', Method.post, body, {});
  }

  //Хэрэглэгчийн төлбөр төлсөн эсэхийг шалгах
  Future checkQpayPayment() async {
    return DioClient().sendRequest('checkQpayPayment', Method.post, [], {});
  }

  //Жолоочийн байршлыг авах
  Future getDriverPositionStream(int orderId) async {
    return DioClient().sendRequest(
        'getDriverPositionStream?orderId=$orderId', Method.post, [], {});
  }

  //Хэрэглэгч бүртгэлээ устгах
  Future deleteUserAccount() async {
    return DioClient().sendRequest('deleteUserAccount', Method.post, [], {});
  }

  //Бүх байршилуудыг датаг авах
  Future getLocationList() async {
    return DioClient().sendRequest('getLocationList', Method.post, [], {});
  }

  //Бүх байршилуудыг датаг авах
  Future getSectionInfo(int storeId) async {
    return DioClient()
        .sendRequest('getSectionInfo?storeId=$storeId', Method.post, [], {});
  }

  //Бүх байршилуудыг датаг авах
  Future checkUserAddress(int storeId) async {
    return DioClient()
        .sendRequest('checkUserAddress?storeId=$storeId', Method.post, [], {});
  }

  //Бүх байршилуудыг датаг авах
  Future calculateDeliveryPrice(dynamic body) async {
    return DioClient()
        .sendRequest('calculateDeliveryPrice', Method.post, body, {});
  }

  //Захиалгын үнэлгээг дуудах
  Future getOrderRating(dynamic body) async {
    return DioClient().sendRequest('getOrderRating', Method.post, body, {});
  }

  //Хэрэглэгч хүргэлтэнд үнэлгээ өгөх
  Future userRateDelivery(dynamic body) async {
    return DioClient().sendRequest('userRateDelivery', Method.post, body, {});
  }

  //Хэрэглэгч хүргэлтэнд үнэлгээ өгөх
  Future saveUserAddress(dynamic body) async {
    return DioClient().sendRequest('saveUserAddress', Method.post, body, {});
  }
}
