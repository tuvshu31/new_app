import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/api/dio_instance.dart';

class DriverApi {
  static final DriverApi _singleton = DriverApi._internal();
  factory DriverApi() => _singleton;
  DriverApi._internal();

  //Жолоочийн мэдээллийг дуудах
  Future getDriverInfo() async {
    return DioClient().sendRequest('getDriverInfo', Method.post, [], {});
  }

  //Жолооч оnline-offline болох
  Future driverTurOnOff(bool isOpen) async {
    return DioClient()
        .sendRequest('driverTurOnOff?isOpen=$isOpen', Method.post, [], {});
  }

  //Жолоочийн байршлыг хадгалах
  Future updateDriverLoc(dynamic body) async {
    return DioClient().sendRequest('updateDriverLoc', Method.post, body, {});
  }

  //Жолооч дуудлагыг зөвшөөрөх
  Future driverAcceptOrder(int orderId) async {
    return DioClient()
        .sendRequest('driverAcceptOrder?orderId=$orderId', Method.post, [], {});
  }

  //Жолоочийн хүргэж байгаа захиалгын мэдээллийг авах
  Future getCurrentOrderInfo() async {
    return DioClient().sendRequest('getCurrentOrderInfo', Method.post, [], {});
  }

  //
  Future driverArrived() async {
    return DioClient().sendRequest('driverArrived', Method.post, [], {});
  }

  Future driverReceived(int orderId) async {
    return DioClient()
        .sendRequest('driverReceived?orderId=$orderId', Method.post, [], {});
  }

  Future driverDelivered(int orderId) async {
    return DioClient()
        .sendRequest('driverDelivered?orderId=$orderId', Method.post, [], {});
  }

  Future driverFinished() async {
    return DioClient().sendRequest('driverFinished', Method.post, [], {});
  }

  Future getAllPreparingOrders() async {
    return DioClient()
        .sendRequest('getAllPreparingOrders', Method.post, [], {});
  }

  Future updateDriverLocation(dynamic body) async {
    return DioClient()
        .sendRequest('updateDriverLocation', Method.post, body, {});
  }

  Future getDriverPaymentsByWeeks() async {
    return DioClient()
        .sendRequest('getDriverPaymentsByWeeks', Method.post, [], {});
  }

  Future getDriverDeliveries() async {
    return DioClient().sendRequest('getDriverDeliveries', Method.post, [], {});
  }

  Future getDriverDeliveryDetails(String date) async {
    return DioClient().sendRequest(
        'getDriverDeliveryDetails?date=$date', Method.post, [], {});
  }

  //Жолоочийн тусламж хэсгийн мэдээллүүдийг дуудах
  Future getDriverHelpContent() async {
    return DioClient().sendRequest('getDriverHelpContent', Method.post, [], {});
  }

  //Жолоочийн нууц үгийг шалгах
  Future checkDriverPassword(String password) async {
    return DioClient().sendRequest(
        'checkDriverPassword?password=$password', Method.post, [], {});
  }

  //Захиалгын нууц кодыг шалгах
  Future checkOrder4digitCode(int orderId, String text) async {
    return DioClient().sendRequest(
        'checkOrder4digitCode?orderId=$orderId&text=$text',
        Method.post, [], {});
  }

  //Жолоочийн firebase token-г хадгалах
  Future saveDriverToken(String token) async {
    var body = {"token": token};
    return DioClient().sendRequest('saveDriverToken', Method.post, body, {});
  }
}
