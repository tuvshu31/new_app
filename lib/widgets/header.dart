import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
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
  final bool centerTitle;
  final dynamic bottomSheet;
  final bool isMainPage;
  final bool customBottom;
  final double actionWidth;
  final dynamic customTitle;
  final IconData actionIcon;
  final dynamic bottomNavigation;
  final dynamic customLeading;
  final dynamic customActions;
  final int leadingWidth;
  final int appBarElevation;
  final dynamic floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;

  const CustomHeader({
    this.withCartAmount = false,
    this.actionWidth = 56,
    this.appBarElevation = 0,
    this.leadingWidth = 56,
    this.withTabBar = false,
    this.isMainPage = false,
    this.isScrollable = false,
    this.floatingActionButton,
    this.actionIcon = IconlyLight.buy,
    this.centerTitle = false,
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
    this.floatingActionButtonLocation = FloatingActionButtonLocation.endFloat,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader>
    with SingleTickerProviderStateMixin {
  final _navCtx = Get.put(NavigationController());

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
              leading: _leading(widget.customLeading, widget.isMainPage),
              backgroundColor: MyColors.white,
              elevation: widget.appBarElevation.toDouble(),
              centerTitle: widget.centerTitle,
              titleSpacing: 0,
              title: _title(widget.customTitle, widget.title, widget.subtitle),
              actions: [_actions(widget.customActions, widget.actionIcon)],
              bottom: widget.tabBar,
            ),
            bottomSheet: widget.bottomSheet,
            floatingActionButton: widget.floatingActionButton ?? Container(),
            floatingActionButtonLocation: widget.floatingActionButtonLocation,
            body: widget.body,
          ),
        ),
      ),
    );
  }

  Widget _actions(dynamic customActions, IconData icon) {
    return SizedBox(
      width: widget.actionWidth,
      child: Center(
          child: customActions ??
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                      Get.back();
                      _navCtx.onItemTapped(2);
                    },
                    icon: Icon(
                      icon,
                      size: 20,
                      color: MyColors.black,
                    ),
                  ),
                  // Obx(
                  //   () => Positioned(
                  //     top: 6,
                  //     right: 8,
                  //     child: Container(
                  //       padding: const EdgeInsets.all(4),
                  //       decoration: const BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: Colors.red,
                  //       ),
                  //       child: Text(
                  //         _cartCtx.cartItemCount.value.toString(),
                  //         style: const TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 10,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              )),
    );
  }

  Widget _leading(dynamic customLeading, bool mainPage) {
    return customLeading ??
        CustomInkWell(
          onTap: () {
            mainPage ? _navCtx.onItemTapped(0) : Get.back();
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
}
