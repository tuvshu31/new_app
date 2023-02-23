import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/text.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
          : !_driverCtx.isGPSActive.value
              ? _noGPSView()
              : GoogleMap(
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
            text:
                "Та идэвхгүй байна. Идэвхжүүлэх товчийг дарж асаана уу бла бла бла...",
          ),
        )
      ],
    );
  }

  Widget _noGPSView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image(
          width: Get.width,
          image: const AssetImage(
            "assets/images/png/app/gps_driver.png",
          ),
        ),
        Padding(
          padding: EdgeInsets.all(Get.width * .1),
          child: const CustomText(
            textAlign: TextAlign.center,
            color: MyColors.gray,
            text: "Gps асаахгүй бол ажиллахгүй өрбыйодроөолдбый бла бла бла...",
          ),
        ),
        SizedBox(
          width: Get.width * .5,
          child: CustomButton(
            isFullWidth: false,
            text: "GPS асаах",
            onPressed: () {},
          ),
        )
      ],
    );
  }
}
