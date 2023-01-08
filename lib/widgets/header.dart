import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class CustomHeader extends StatefulWidget {
  final String title;
  final bool withCartAmount;
  final dynamic tabBar;
  final dynamic body;
  final bool isScrollable;
  final bool withTabBar;
  final dynamic onChanged;
  final bool withSearchBar;
  final dynamic subtitle;
  final dynamic totalAmount;
  final int? cartLength;
  final dynamic bottomSheet;
  final bool isMainPage;
  final bool customBottom;
  final dynamic customTitle;
  final IconData actionIcon;
  final dynamic bottomNavigation;
  final dynamic customLeading;
  final dynamic customActions;
  final int leadingWidth;
  final int appBarElevation;
  final dynamic floatingActionButton;

  const CustomHeader({
    this.withCartAmount = false,
    this.appBarElevation = 0,
    this.leadingWidth = 56,
    this.withTabBar = false,
    this.isMainPage = false,
    this.isScrollable = false,
    this.floatingActionButton,
    this.actionIcon = IconlyLight.buy,
    this.subtitle,
    this.customLeading,
    this.onChanged,
    this.totalAmount,
    this.cartLength,
    this.customBottom = false,
    this.tabBar,
    this.body,
    this.bottomNavigation,
    this.withSearchBar = false,
    this.customTitle,
    this.bottomSheet,
    this.customActions,
    this.title = '',
    Key? key,
  }) : super(key: key);

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader>
    with SingleTickerProviderStateMixin {
  final _navCtrl = Get.put(NavigationController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.white,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: MyColors.white,
            appBar: AppBar(
              leadingWidth: widget.leadingWidth.toDouble(),
              leading:
                  _leading(widget.customLeading, widget.isMainPage, _navCtrl),
              backgroundColor: MyColors.white,
              elevation: widget.appBarElevation.toDouble(),
              centerTitle: false,
              titleSpacing: 0,
              title: _title(widget.customTitle, widget.title, widget.subtitle),
              actions: [
                _actions(widget.customActions, widget.actionIcon, _navCtrl)
              ],
              bottom: widget.tabBar,
            ),
            bottomSheet: widget.bottomSheet,
            body: widget.body,
          ),
        ),
      ),
    );
  }

  Widget _actions(dynamic customActions, IconData icon, dynamic controller) {
    return SizedBox(
      width: 56,
      child: Center(
        child: customActions ??
            CustomInkWell(
              onTap: () {
                controller.onItemTapped(2);
              },
              borderRadius: BorderRadius.circular(8),
              child: Icon(
                icon,
                size: 20,
                color: MyColors.black,
              ),
            ),
      ),
    );
  }
}

Widget _leading(dynamic customLeading, bool mainPage, dynamic controller) {
  return customLeading ??
      CustomInkWell(
        onTap: () {
          mainPage ? controller.onItemTapped(0) : Get.back();
        },
        child: const SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Icon(
            // FontAwesomeIcons.longArrowAltLeft,
            IconlyLight.arrow_left,
            color: MyColors.black,
            size: 20,
          ),
        ),
      );
}

Widget _title(dynamic customTitle, String title, dynamic subtitle) {
  return customTitle ??
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 16,
            color: MyColors.black,
          ),
          subtitle ?? Container()
        ],
      );
}
