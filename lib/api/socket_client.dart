import 'dart:developer';
import 'package:get/get.dart';
import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:socket_io_client/socket_io_client.dart';

final _userCtx = Get.put(UserController());
final _storeCtx = Get.put(StoreController());
final _driverCtx = Get.put(DriverController());

class SocketClient {
  static final SocketClient _singleton = SocketClient._internal();
  factory SocketClient() => _singleton;
  SocketClient._internal();

  Future<void> onConnect(Socket socket) async {
    var body = {
      "socketId": socket.id.toString(),
      "role": RestApiHelper.getUserRole()
    };
    var response = await UserApi().saveSocketIdNew(body);
  }

  Future<void> onDisconnect(data) async {
    log("Socket disconnected!");
  }

  Future<void> onMessage(data) async {
    actionSwitcher(data);
  }

  Future<void> onAccept(data) async {
    actionSwitcher(data);
  }

  Future<void> onAccepted(data) async {
    actionSwitcher(data);
  }

  void actionSwitcher(data) {
    String role = data["role"];
    if (role == RestApiHelper.getUserRole()) {
      if (role == "user") {
        _userCtx.handleSocketActions(data);
      }
      if (role == "store") {
        _storeCtx.handleSocketActions(data);
      }
      if (role == "driver") {
        _driverCtx.handleSocketActions(data);
      }
    }
  }
}
