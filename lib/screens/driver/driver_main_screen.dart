import 'package:Erdenet24/api/dio_requests/driver.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/main.dart';
import 'package:Erdenet24/screens/driver/driver_drawer_screen.dart';
import 'package:Erdenet24/screens/driver/driver_order_item.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen>
    with WidgetsBindingObserver {
  bool loading = false;
  final _driverCtx = Get.put(DriverController());
  final _loginCtx = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _driverCtx.getDriverInfo();
    _loginCtx.saveUserToken();
    _driverCtx.connectToSocket();
    _driverCtx.getAllPreparingOrders();
    _driverCtx.determinePosition();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (socket.disconnected) {
        _driverCtx.connectToSocket();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: _appbar(),
            drawer: const DriverDrawerScreen(),
            body: !_driverCtx.isOnline.value
                ? customEmptyWidget("Та идэвхгүй байна")
                : _driverCtx.fetchingOrders.value && _driverCtx.orders.isEmpty
                    ? listShimmerWidget()
                    : !_driverCtx.fetchingOrders.value &&
                            _driverCtx.orders.isEmpty
                        ? _noOrderWidget()
                        : _orderListWidget()),
      ),
    );
  }

  Widget _orderListWidget() {
    return RefreshIndicator(
      color: MyColors.primary,
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 600));
        _driverCtx.refreshOrders();
        _driverCtx.connectToSocket();
      },
      child: ListView.separated(
        controller: _driverCtx.scrollController.value,
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder: (context, index) {
          return Container(
            height: 7,
            color: MyColors.fadedGrey,
          );
        },
        itemCount: _driverCtx.orders.length,
        itemBuilder: (context, index) {
          var item = _driverCtx.orders[index];
          return DriverOrderItem(item: item);
        },
      ),
    );
  }

  Widget _noOrderWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              _driverCtx.refreshOrders();
              _driverCtx.connectToSocket();
            },
            icon: const Icon(
              Icons.refresh_rounded,
              size: 32,
            ),
          ),
          SizedBox(height: Get.width * .04),
          const Text(
            "Захиалга байхгүй байна",
            style: TextStyle(
              color: MyColors.gray,
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      backgroundColor: MyColors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      title: _driverCtx.driverInfo.isNotEmpty && _driverCtx.isOnline.value
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 12,
                ),
                SizedBox(width: 8),
                Text(
                  "Online",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ],
            )
          : const Text(
              "Offline",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
      actions: [
        CupertinoSwitch(
          value: _driverCtx.isOnline.value,
          onChanged: (value) {
            _driverCtx.driverTurOnOff();
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
