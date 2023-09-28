// import 'package:Erdenet24/utils/enums.dart';
// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:iconly/iconly.dart';

// import 'package:Erdenet24/widgets/text.dart';
// import 'package:Erdenet24/utils/styles.dart';
// import 'package:Erdenet24/widgets/header.dart';
// import 'package:Erdenet24/utils/shimmers.dart';
// import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
// import 'package:Erdenet24/widgets/inkwell.dart';
// import 'package:Erdenet24/widgets/snackbar.dart';
// import 'package:Erdenet24/api/dio_requests.dart';
// import 'package:Erdenet24/api/restapi_helper.dart';
// import 'package:Erdenet24/controller/login_controller.dart';
// import 'package:Erdenet24/screens/user/user_profile_help_screen.dart';
// import 'package:Erdenet24/screens/user/user_profile_phone_edit_screen.dart';
// import 'package:Erdenet24/screens/user/user_profile_address_edit_screen.dart';

// class UserProfileScreen extends StatefulWidget {
//   const UserProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }

// class _UserProfileScreenState extends State<UserProfileScreen> {
//   dynamic _user = [];
//   final _loginCtx = Get.put(LoginController());

//   @override
//   void initState() {
//     super.initState();
//     getUserInfo();
//   }

//   void getUserInfo() async {
//     dynamic res = await RestApi().getUser(RestApiHelper.getUserId());
//     dynamic data = Map<String, dynamic>.from(res);
//     setState(() {
//       _user = data["data"];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomHeader(
//         isMainPage: true,
//         title: 'Профайл',
//         customActions: Container(),
 
//   }

// }
