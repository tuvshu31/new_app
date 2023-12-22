import 'package:Erdenet24/api/local_notification.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';

class DriverController extends GetxController {
  final player = AudioPlayer();
  RxMap order = {}.obs;
  RxBool isOnline = false.obs;
  RxMap driverInfo = {}.obs;
  RxMap driverLoc = {}.obs;
  Rx<DriverStatus> driverStatus = DriverStatus.withoutOrder.obs;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  void handleSocketActions(Map payload) async {
    String action = payload["action"];
    if (action == "waitingForDriver") {
      LocalNotification.showIncomingSoundNotification(
        id: payload["id"],
        title: payload["store"],
        body: "Шинэ захиалга ирлээ",
      );
      driverStatus.value = DriverStatus.incoming;
      if (order.isEmpty) {
        order.value = payload;
      }
    } else if (action == "preparing") {}
  }

  void stopSound() async {
    player.stop();
  }

  void saveUserToken() {
    _messaging.getToken().then((token) async {
      if (token != null) {
        var body = {"mapToken": token};
        await RestApi().updateUser(RestApiHelper.getUserId(), body);
      }
    });
  }

  void turnOnOff(dynamic body) async {
    CustomDialogs().showLoadingDialog();
    saveUserToken();
    dynamic user =
        await RestApi().updateDriver(RestApiHelper.getUserId(), body);
    if (user != null) {
      dynamic res = Map<String, dynamic>.from(user);
      isOnline.value = res["data"]["isOpen"];
    }
    Get.back();
  }
}
