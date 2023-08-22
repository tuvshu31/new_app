import 'package:Erdenet24/api/dio_instance.dart';
import 'package:Erdenet24/api/dio_message.dart';
import 'package:Erdenet24/utils/enums.dart';

class RestApi {
  static final RestApi _singleton = RestApi._internal();
  factory RestApi() => _singleton;
  RestApi._internal();

  //Бүх ангиллуудыг авах
  Future getCategories(dynamic query) async {
    return DioClient().sendRequest('categories', Method.get, [], query);
  }

  //Ангилал доторх бараануудын тоог авах
  Future getProductCount(dynamic query) async {
    return DioClient().sendRequest('products/count', Method.get, [], query);
  }

  //Ангилал үүсгэх
  Future createCategory(dynamic body) async {
    return DioClient().sendRequest('categories', Method.post, body, {});
  }

  //Нэг ангилал авах
  Future getCategory(int id) async {
    return DioClient().sendRequest('categories/$id', Method.get, [], {});
  }

  //Ангиллын мэдээлэл өөрчлөх
  Future updateCategory(int id, dynamic body) async {
    return DioClient().sendRequest('categories/$id', Method.put, body, {});
  }

  //Ангилал устгах
  Future deleteCategory(int id) async {
    return DioClient().sendRequest('categories/$id', Method.delete, [], {});
  }

  //Хэрэглэгч бүх бараануудыг авах
  Future getProducts(dynamic query) async {
    return DioClient().sendRequest('products/products', Method.get, [], query);
  }

  //Хэрэглэгчийн сагсанд байгаа бүх бараануудыг шалгах
  Future checkUserCartProducts(dynamic body) async {
    return DioClient()
        .sendRequest('products/checkUserCartProducts', Method.get, body, {});
  }

  //Хэрэглэгч бараануудыг хайж авах
  Future searchProducts(dynamic body) async {
    return DioClient()
        .sendRequest('products/getSearchSuggessions', Method.get, body, {});
  }

  //Хайсан бараануудыг авах
  Future getSearchResults(dynamic body) async {
    return DioClient()
        .sendRequest('products/getSearchResults', Method.get, body, {});
  }

  //Дэлгүүр бүх бараануудыг авах
  Future getStoreProducts(dynamic query) async {
    return DioClient().sendRequest('products/store', Method.get, [], query);
  }

  //Бараа үүсгэх
  Future createProduct(dynamic body) async {
    return DioClient().sendRequest('products', Method.post, body, {});
  }

  //Нэг бараа авах
  Future getProduct(int id) async {
    return DioClient().sendRequest('products/$id', Method.get, [], {});
  }

  //Барааны мэдээлэл өөрчлөх
  Future updateProduct(int id, dynamic body) async {
    return DioClient().sendRequest('products/$id', Method.put, body, {});
  }

  //Бараа устгах
  Future deleteProduct(int id) async {
    return DioClient().sendRequest('products/$id', Method.delete, [], {});
  }

  //Барааны зурагнуудын тоог авах
  Future getProductImgCount(int id) async {
    return DioClient().sendRequest('products/$id/count', Method.get, [], {});
  }

  //Хэрэглэгч бүртгэлээ устгах
  Future deleteUser(int id) async {
    return DioClient().sendRequest('users/$id', Method.delete, [], {});
  }

  //Хэрэглэгчийн нэвтрэх эрхийг шалгах
  Future checkUser(String phone) async {
    return DioClient().sendRequest('users/$phone/check', Method.get, [], {});
  }

  //Хэрэглэгч бараа хадгалах
  Future saveUserProduct(dynamic body) async {
    return DioClient().sendRequest('saved-products', Method.post, body, {});
  }

  //Хэрэглэгчийн хадгалсан бараануудыг авах
  Future getUserProducts(int userId, dynamic query) async {
    return DioClient()
        .sendRequest('saved-products/$userId', Method.get, [], query);
  }

  //Хэрэглэгчийн хадгалсан барааг устгах
  Future deleteUserProduct(dynamic query) async {
    return DioClient().sendRequest('saved-products', Method.delete, [], query);
  }

  //Бүх хэрэглэгчийн мэдээллийг авах
  Future getUsers(dynamic query) async {
    return DioClient().sendRequest('users', Method.get, [], query);
  }

  //Тухайн дэлгүүрийн ангиллуудыг авах
  Future getStoreCategories(int id) async {
    return DioClient().sendRequest('users/$id/store', Method.get, [], {});
  }

  //Нэг хэрэглэгчийн мэдээллийг авах
  Future getUser(int id) async {
    return DioClient().sendRequest('users/$id', Method.get, [], {});
  }

  //Тухайн хэрэглэгчийн мэдээллийг засах
  Future updateUser(int userId, dynamic body) async {
    return DioClient().sendRequest('users/$userId', Method.put, body, {});
  }

  //Бүх дэлгүүрүүдийг авах
  Future getStores(dynamic query) async {
    return DioClient().sendRequest('stores', Method.get, [], query);
  }

  //Хэрэглэгч логин хийх
  Future loginUser(dynamic body) async {
    return DioClient().sendRequest('users/login', Method.post, body, {});
  }

  //Хэрэглэгч бүртгэл үүсгэх
  Future registerUser(dynamic body) async {
    return DioClient().sendRequest('users', Method.post, body, {});
  }

  //Захиалга үүсгэх
  Future createOrder(dynamic body) async {
    return DioClient().sendRequest('orders', Method.post, body, {});
  }

  //Тухайн хэрэглэгчийн захиалгыг авах
  Future getOrders(dynamic query) async {
    return DioClient().sendRequest('orders', Method.get, [], query);
  }

  //Тухайн хэрэглэгчийн захиалгыг авах
  Future checkDriverAccepted(int id) async {
    return DioClient()
        .sendRequest('users/checkDriverAccepted?id=$id', Method.post, [], {});
  }

  //Шинэ захиалгын мэдээллийг жолооч руу илгээх
  Future assignDriver(int id) async {
    return DioClient()
        .sendRequest('users/drivers/assignDriver?id=$id', Method.post, [], {});
  }

  //Шинэ захиалгын мэдээллийг жолооч руу илгээх
  Future getNotifiedDrivers(int id, int driverId) async {
    return DioClient().sendRequest(
        'users/drivers/getNotifiedDrivers?id=$id&driverId=$driverId',
        Method.post, [], {});
  }

  //Жолооч захиалгыг хүлээн авах
  Future acceptOrder(int id, int driverId) async {
    return DioClient().sendRequest(
        'users/drivers/acceptOrder?id=$id&driverId=$driverId',
        Method.post, [], {});
  }

  //Жолооч захиалгыг цуцлах
  Future arrived(int id, int driverId) async {
    return DioClient().sendRequest(
        'users/drivers/arrived?id=$id&driverId=$driverId', Method.post, [], {});
  }

  //Жолооч захиалгыг цуцлах
  Future finished(int id, int driverId) async {
    return DioClient().sendRequest(
        'users/drivers/finished?id=$id&driverId=$driverId',
        Method.post, [], {});
  }

  //Жолооч захиалгыг цуцлах
  Future received(int id, int driverId) async {
    return DioClient().sendRequest(
        'users/drivers/received?id=$id&driverId=$driverId',
        Method.post, [], {});
  }

  //Жолооч захиалгыг цуцлах
  Future checkDriverOrder(int driverId) async {
    return DioClient().sendRequest(
        'users/drivers/checkDriverOrder?driverId=$driverId',
        Method.post, [], {});
  }

  //Логин хийсэн жолоочийн төлбөрийн мэдээллийг авах
  Future driverPayments(dynamic body) async {
    return DioClient()
        .sendRequest('users/drivers/driverPayments', Method.get, body, {});
  }

  //Жолоочийн бонусыг авах
  Future getDriverBonus(int driverId) async {
    return DioClient().sendRequest(
        'users/drivers/driverBonus?driverId=$driverId', Method.post, [], {});
  }

  //Жолоочийн бонусыг авах
  Future driverDeliveries(int driverId) async {
    return DioClient().sendRequest(
        'users/drivers/driverDeliveries?driverId=$driverId',
        Method.post, [], {});
  }

  //Жолоочийн бонусыг авах
  Future driverDeliveriesDetails(int driverId, String date) async {
    return DioClient().sendRequest(
        'users/drivers/driverDeliveriesDetails?driverId=$driverId&date=$date',
        Method.post, [], {});
  }

  //Жолоочийн төлбөрийн мэдээллийг авах
  Future driverPaymentsByWeeks(int driverId) async {
    return DioClient().sendRequest(
        'users/drivers/driverPaymentsByWeeks?driverId=$driverId',
        Method.post, [], {});
  }

  //Захиалгын мэдээлэл өөрчлөх
  Future updateOrder(int id, dynamic body) async {
    return DioClient()
        .sendRequest('orders/updateOrder2/$id', Method.put, body, {});
  }

  //Тухайн дэлгүүрийн захиалгыг авах
  Future getStoreOrders(int id, dynamic query) async {
    return DioClient().sendRequest('orders/store/$id', Method.get, [], {});
  }

  Future getOrdersForAdmin() async {
    return DioClient().sendRequest('orders', Method.get, [], {});
  }

  //Захиалгын бараануудыг үүсгэх
  Future createOrderProducts(dynamic body) async {
    return DioClient().sendRequest('order-products', Method.post, body, {});
  }

  //Захиалгын бараануудыг авах
  Future getOrderProducts(dynamic query) async {
    return DioClient().sendRequest('order-products', Method.get, [], query);
  }

  //Зураг оруулах
  Future uploadImage(String type, int id, dynamic body) async {
    return DioClient().sendFile("$type/$id/uploadphoto", Method.post, body);
  }

  //Зураг устгах
  Future deleteImage(String type, int id) async {
    return DioClient()
        .sendRequest("$type/$id/deletephoto", Method.delete, [], {});
  }

  Future sendAuthCode(String phone, String code) async {
    return DioMessage()
        .sendMessage("send", phone, "Erdenet24 nevtrekh kod: $code");
  }

  //Жолоочийн мэдээллийг авах
  Future getDriver(int id) async {
    return DioClient().sendRequest('users/drivers/$id', Method.get, [], {});
  }

  //Тухайн жолоочийн мэдээллийг засах
  Future updateDriver(int driverId, dynamic body) async {
    return DioClient()
        .sendRequest('users/drivers/$driverId', Method.put, body, {});
  }

  //Qpay-төлбөрөө төлөх
  Future qpayPayment(dynamic body) async {
    return DioClient()
        .sendRequest('payment/createInvoice2', Method.post, body, {});
  }

  //Байршлуудын мэдээлэл авах
  Future getLocations() async {
    return DioClient().sendRequest('locations', Method.get, [], {});
  }

//Token-г subscribe хийх
  Future subscribeToFirebase(String role, String token) async {
    var body = {"role": role, "token": token};
    return DioClient()
        .sendRequest('firebase/subscribeToTopic', Method.put, body, {});
  }

  //Тухайн барааг багц мөн эсэхийг шалгах
  Future checkIncludedProducts(int productId) async {
    return DioClient().sendRequest(
        'products/checkIncludedProducts?productId=$productId',
        Method.post, [], {});
  }
}
