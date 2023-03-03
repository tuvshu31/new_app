import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/screens/user/user_profile_main_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _loginCtrl = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
        isMainPage: true,
        title: 'Профайл',
        customActions: Container(),
        body: const UserPage());
  }
}
