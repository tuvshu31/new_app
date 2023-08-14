import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/screens/user/user_search_view.dart';
import 'package:Erdenet24/screens/user/user_store_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final _navCtx = Get.put(NavigationController());
  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _navCtx.searchViewController.value,
      children: const [
        UserSearchView(),
        UserStoreListView(),
      ],
    );
  }
}
