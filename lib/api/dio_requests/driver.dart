import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/api/dio_instance.dart';
import 'package:Erdenet24/api/restapi_helper.dart';

int driverId = RestApiHelper.getUserId();

class DriverApi {
  static final DriverApi _singleton = DriverApi._internal();
  factory DriverApi() => _singleton;
  DriverApi._internal();

  //Жолоочийн мэдээллийг дуудах
  Future getDriverInfo() async {
    return DioClient()
        .sendRequest('getDriverInfo?driverId=$driverId', Method.post, [], {});
  }

  //Жолооч оnline-offline болох
  Future driverTurOnOff(bool isOpen) async {
    return DioClient().sendRequest(
        'driverTurOnOff?driverId=$driverId&isOpen=$isOpen',
        Method.post, [], {});
  }

  //Жолоочийн байршлыг хадгалах
  Future updateDriverLoc(dynamic body) async {
    return DioClient().sendRequest(
        'updateDriverLoc?driverId=$driverId', Method.post, body, {});
  }

  //Жолооч дуудлагыг зөвшөөрөх
  Future driverAcceptOrder(int orderId) async {
    return DioClient().sendRequest(
        'driverAcceptOrder?driverId=$driverId&orderId=$orderId',
        Method.post, [], {});
  }

  //Жолоочийн хүргэж байгаа захиалгын мэдээллийг авах
  Future getCurrentOrderInfo() async {
    return DioClient().sendRequest(
        'getCurrentOrderInfo?driverId=$driverId', Method.post, [], {});
  }

  //
  Future driverArrived() async {
    return DioClient()
        .sendRequest('driverArrived?driverId=$driverId', Method.post, [], {});
  }

  Future driverReceived() async {
    return DioClient()
        .sendRequest('driverReceived?driverId=$driverId', Method.post, [], {});
  }

  Future driverDelivered() async {
    return DioClient()
        .sendRequest('driverDelivered?driverId=$driverId', Method.post, [], {});
  }

  Future driverFinished() async {
    return DioClient()
        .sendRequest('driverFinished?driverId=$driverId', Method.post, [], {});
  }

  Future getAllPreparingOrders() async {
    return DioClient()
        .sendRequest('getAllPreparingOrders', Method.post, [], {});
  }
}
