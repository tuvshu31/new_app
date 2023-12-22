// import 'dart:developer';

// import 'package:Erdenet24/api/dio_requests.dart';
// import 'package:Erdenet24/api/restapi_helper.dart';
// import 'package:Erdenet24/controller/driver_controller.dart';
// import 'package:Erdenet24/controller/login_controller.dart';
// import 'package:Erdenet24/utils/routes.dart';
// import 'package:Erdenet24/utils/styles.dart';
// import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
// import 'package:Erdenet24/widgets/inkwell.dart';
// import 'package:Erdenet24/widgets/shimmer.dart';
// import 'package:Erdenet24/widgets/text.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:iconly/iconly.dart';
// import 'package:app_settings/app_settings.dart';

// final _loginCtx = Get.put(LoginController());

// class DriverDrawerScreen extends StatefulWidget {
//   const DriverDrawerScreen({super.key});

//   @override
//   State<DriverDrawerScreen> createState() => _DriverDrawerScreenState();
// }

// class _DriverDrawerScreenState extends State<DriverDrawerScreen> {
//   bool loading = false;
//   List driverInfo = [];
//   @override
//   void initState() {
//     super.initState();
//     getDriverInfo();
//   }

//   Future<void> getDriverInfo() async {
//     loading = true;
//     dynamic res = await RestApi().getUser(RestApiHelper.getUserId());
//     if (res != null) {
//       dynamic response = Map<String, dynamic>.from(res);
//       driverInfo = [response["data"]];
//       log(response["data"].toString());
//     }
//     loading = false;
//     setState(() {});
//   }

//   String generateDriverName(driverInfo) {
//     var first = driverInfo["firstName"] ?? "";
//     var last = driverInfo["lastName"] ?? "";
//     var name = "${first[0]}. $last";
//     return name;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return 
//   }
// }


