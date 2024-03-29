import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/api/dio_instance.dart';
import 'package:Erdenet24/api/restapi_helper.dart';

class DriverApi {
  static final DriverApi _singleton = DriverApi._internal();
  factory DriverApi() => _singleton;
  DriverApi._internal();

  //Жолоочийн мэдээллийг дуудах
  Future getDriverInfo() async {
    int driverId = RestApiHelper.getUserId();
    return DioClient()
        .sendRequest('getDriverInfo?driverId=$driverId', Method.post, [], {});
  }

  //Жолооч оnline-offline болох
  Future driverTurOnOff(bool isOpen) async {
    int driverId = RestApiHelper.getUserId();
    return DioClient().sendRequest(
        'driverTurOnOff?driverId=$driverId&isOpen=$isOpen',
        Method.post, [], {});
  }

  //Жолоочийн байршлыг хадгалах
  Future updateDriverLoc(dynamic body) async {
    int driverId = RestApiHelper.getUserId();

    return DioClient().sendRequest(
        'updateDriverLoc?driverId=$driverId', Method.post, body, {});
  }

  //Жолооч дуудлагыг зөвшөөрөх
  Future driverAcceptOrder(int orderId) async {
    int driverId = RestApiHelper.getUserId();

    return DioClient().sendRequest(
        'driverAcceptOrder?driverId=$driverId&orderId=$orderId',
        Method.post, [], {});
  }

  //Жолоочийн хүргэж байгаа захиалгын мэдээллийг авах
  Future getCurrentOrderInfo() async {
    int driverId = RestApiHelper.getUserId();

    return DioClient().sendRequest(
        'getCurrentOrderInfo?driverId=$driverId', Method.post, [], {});
  }

  //
  Future driverArrived() async {
    int driverId = RestApiHelper.getUserId();

    return DioClient()
        .sendRequest('driverArrived?driverId=$driverId', Method.post, [], {});
  }

  Future driverReceived(int orderId) async {
    int driverId = RestApiHelper.getUserId();

    return DioClient().sendRequest(
        'driverReceived?driverId=$driverId&orderId=$orderId',
        Method.post, [], {});
  }

  Future driverDelivered(int orderId) async {
    int driverId = RestApiHelper.getUserId();

    return DioClient().sendRequest(
        'driverDelivered?driverId=$driverId&orderId=$orderId',
        Method.post, [], {});
  }

  Future driverFinished() async {
    int driverId = RestApiHelper.getUserId();

    return DioClient()
        .sendRequest('driverFinished?driverId=$driverId', Method.post, [], {});
  }

  Future getAllPreparingOrders() async {
    int driverId = RestApiHelper.getUserId();
    return DioClient().sendRequest(
        'getAllPreparingOrders?driverId=$driverId', Method.post, [], {});
  }

  Future updateDriverLocation(dynamic body) async {
    int driverId = RestApiHelper.getUserId();
    return DioClient().sendRequest(
        'updateDriverLocation?driverId=$driverId', Method.post, body, {});
  }

  Future getDriverPaymentsByWeeks() async {
    int driverId = RestApiHelper.getUserId();
    return DioClient().sendRequest(
        'getDriverPaymentsByWeeks?driverId=$driverId', Method.post, [], {});
  }

  Future getDriverDeliveries() async {
    int driverId = RestApiHelper.getUserId();
    return DioClient().sendRequest(
        'getDriverDeliveries?driverId=$driverId', Method.post, [], {});
  }

  Future getDriverDeliveryDetails(String date) async {
    int driverId = RestApiHelper.getUserId();
    return DioClient().sendRequest(
        'getDriverDeliveryDetails?driverId=$driverId&date=$date',
        Method.post, [], {});
  }

  //Жолоочийн тусламж хэсгийн мэдээллүүдийг дуудах
  Future getDriverHelpContent() async {
    return DioClient().sendRequest('getDriverHelpContent', Method.post, [], {});
  }

  //Жолоочийн нууц үгийг шалгах
  Future checkDriverPassword(String password) async {
    int driverId = RestApiHelper.getUserId();
    return DioClient().sendRequest(
        'checkDriverPassword?driverId=$driverId&password=$password',
        Method.post, [], {});
  }

  //Захиалгын нууц кодыг шалгах
  Future checkOrder4digitCode(int orderId, String text) async {
    return DioClient().sendRequest(
        'checkOrder4digitCode?orderId=$orderId&text=$text',
        Method.post, [], {});
  }
}
