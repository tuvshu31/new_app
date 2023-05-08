import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';

class DriverScreenMapView extends StatefulWidget {
  const DriverScreenMapView({super.key});

  @override
  State<DriverScreenMapView> createState() => _DriverScreenMapViewState();
}

class _DriverScreenMapViewState extends State<DriverScreenMapView> {
  final _driverCtx = Get.put(DriverController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => !_driverCtx.isOnline.value
          ? _offlineView()
          : Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: false,
                  mapType: MapType.normal,
                  buildingsEnabled: true,
                  myLocationButtonEnabled: true,
                  onCameraMove: _driverCtx.onCameraMove,
                  rotateGesturesEnabled: true,
                  trafficEnabled: false,
                  compassEnabled: false,
                  markers: Set<Marker>.of(_driverCtx.markers.values),
                  initialCameraPosition: CameraPosition(
                    target: _driverCtx.initialPosition.value,
                    zoom: 14.4746,
                  ),
                  onMapCreated: _driverCtx.onMapCreated,
                ),
                Container(
                  height: Get.height * .075,
                  width: double.infinity,
                  color: MyColors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          dense: true,
                          horizontalTitleGap: 0,
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(
                                IconlyLight.wallet,
                              ),
                            ],
                          ),
                          title: const CustomText(
                            text: "Өнөөдрийн орлого:",
                            fontSize: 12,
                          ),
                          subtitle: CustomText(
                              text: convertToCurrencyFormat(
                            _driverCtx.fakeOrderCount.value * 3000,
                            locatedAtTheEnd: true,
                            toInt: true,
                          )),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          dense: true,
                          horizontalTitleGap: 0,
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(
                                IconlyLight.time_circle,
                              ),
                            ],
                          ),
                          title: const CustomText(
                            text: "Идэвхтэй хугацаа:",
                            fontSize: 12,
                          ),
                          subtitle: CustomText(
                            text: _driverCtx.time.value,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget _offlineView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image(
          width: Get.width,
          image: const AssetImage(
            "assets/images/png/app/offline_driver.png",
          ),
        ),
        Padding(
          padding: EdgeInsets.all(Get.width * .1),
          child: const CustomText(
            textAlign: TextAlign.center,
            color: MyColors.gray,
            text: "Та идэвхгүй байна. Идэвхжүүлэх товчийг дарж асаана уу",
          ),
        )
      ],
    );
  }
}
