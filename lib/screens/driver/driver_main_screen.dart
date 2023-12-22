import 'dart:developer';
import 'package:Erdenet24/api/dio_requests/driver.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/screens/driver/views/driver_arrived_view.dart';
import 'package:Erdenet24/screens/driver/views/driver_delivered_view.dart';
import 'package:Erdenet24/screens/driver/views/driver_finished_view.dart';
import 'package:Erdenet24/screens/driver/views/driver_incoming_order_view.dart';
import 'package:Erdenet24/screens/driver/views/driver_received_view.dart';
import 'package:Erdenet24/screens/driver/views/driver_without_order_view.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/custom_loading_widget.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  bool loading = false;
  final _driverCtx = Get.put(DriverController());
  final _loginCtx = Get.put(LoginController());

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(49.02778937705711, 104.04735316811922),
    zoom: 17.4746,
  );

  @override
  void initState() {
    super.initState();
    getDriverInfo();
  }

  void getDriverInfo() async {
    loading = true;
    dynamic getDriverInfo = await DriverApi().getDriverInfo();
    loading = false;
    if (getDriverInfo != null) {
      dynamic response = Map<String, dynamic>.from(getDriverInfo);
      if (response["success"]) {
        log(response.toString());
        _driverCtx.driverInfo.value = response["data"];
      }
    }
    setState(() {});
  }

  void onMapCreated(GoogleMapController controller) {
    int distanceFilter = 1;
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: distanceFilter,
        timeLimit: const Duration(seconds: 1),
      ),
    ).listen((Position? info) async {
      if (_driverCtx.driverInfo["isOpen"] == true) {
        distanceFilter = 50;
      }
      _driverCtx.driverLoc.value = {
        "latitute": info!.latitude,
        "longitute": info.longitude,
        "heading": info.heading,
      };
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              _driverCtx.driverLoc["latitute"],
              _driverCtx.driverLoc["longitute"],
            ),
            zoom: 17.0,
          ),
        ),
      );
      if (_driverCtx.driverInfo["isOpen"] == true) {
        dynamic res = await DriverApi().updateDriverLoc(_driverCtx.driverLoc);
        log(res.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? _driverShimmerScreen()
        : Obx(
            () => WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 1,
                  iconTheme: const IconThemeData(color: Colors.black),
                  centerTitle: true,
                  title: _driverCtx.driverInfo["isOpen"]
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
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          "Offline",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                  actions: const [
                    Icon(IconlyLight.scan),
                    SizedBox(width: 16),
                  ],
                ),
                drawer: _drawer(),
                body: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: false,
                      buildingsEnabled: true,
                      myLocationButtonEnabled: true,
                      rotateGesturesEnabled: true,
                      compassEnabled: false,
                      initialCameraPosition: _initialCameraPosition,
                      onMapCreated: onMapCreated,
                    ),
                    // DriverWithoutOrderView()
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _bottomViewsHandler(_driverCtx.driverStatus.value),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Widget _bottomViewsHandler(DriverStatus status) {
    if (status == DriverStatus.withoutOrder) {
      return const DriverWithoutOrderView();
    } else if (status == DriverStatus.incoming) {
      return const DriverIncomingOrderView();
    } else if (status == DriverStatus.arrived) {
      return const DriverArrivedView();
    } else if (status == DriverStatus.received) {
      return const DriverReceivedView();
    } else if (status == DriverStatus.delivered) {
      return const DriverDeliveredView();
    } else if (status == DriverStatus.finished) {
      return const DriverFinishedView();
    } else {
      return const DriverWithoutOrderView();
    }
  }

  Widget _driverShimmerScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: customLoadingWidget(),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          DrawerHeader(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.white,
                  border: Border.all(width: 1, color: MyColors.background),
                ),
                child: const Icon(
                  Icons.account_balance,
                  size: 40,
                  color: MyColors.grey,
                ),
              ),
              loading
                  ? CustomShimmer(width: Get.width * .2, height: 14)
                  : Text("Name")
            ],
          )),
          _drawerListTile(IconlyLight.user, "Миний бүртгэл", () {
            Get.toNamed(driverSettingsScreenRoute);
          }),
          _drawerListTile(IconlyLight.setting, "Тохиргоо", () {
            AppSettings.openAppSettings();
          }),
          _drawerListTile(IconlyLight.location, "Хүргэлтүүд", () {
            Get.toNamed(driverDeliverListScreenRoute);
          }),
          _drawerListTile(IconlyLight.wallet, "Төлбөр", () {
            Get.toNamed(driverPaymentsScreenRoute);
          }),
          _drawerListTile(IconlyLight.logout, "Аппаас гарах", () {
            CustomDialogs().showLogoutDialog(() {
              _loginCtx.logout();
            });
          }),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _drawerListTile(IconData icon, String title, dynamic onTap) {
    return CustomInkWell(
      borderRadius: BorderRadius.zero,
      onTap: onTap,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: Get.width * .075),
        dense: true,
        minLeadingWidth: Get.width * .07,
        leading: Icon(
          icon,
          color: MyColors.black,
          size: 20,
        ),
        title: CustomText(
          text: title,
          fontSize: 14,
        ),
      ),
    );
  }
}
