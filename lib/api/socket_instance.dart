import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
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
  Socket socket = io(
      "http://192.168.1.191:8000",
      // "https://www.e24api1215.com",
      // prodUrl,
      OptionBuilder()
          .setTransports(['websocket'])
          //add this line
          .enableForceNewConnection() // necessary because otherwise it would reuse old connection
          .disableAutoConnect()
          .build());

  Future<void> connect() async {
    socket.connect();
    socket.on('connect', (data) async {
      log("Successfully connected!");
      var body = {
        "id": RestApiHelper.getUserId(),
        "role": RestApiHelper.getUserRole(),
        "socketId": socket.id.toString(),
      };
      dynamic saveSocketId = await UserApi().saveSocketId(body);
    });
    socket.on('message', (data) async {
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
    });
  }

  Future<void> disconnect() async {
    socket.disconnect();
  }
}
