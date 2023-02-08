import 'dart:developer';
import 'package:Erdenet24/utils/styles.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverScreenMapView extends StatefulWidget {
  const DriverScreenMapView({Key? key}) : super(key: key);

  @override
  State<DriverScreenMapView> createState() => DriverScreenMapViewState();
}

class DriverScreenMapViewState extends State<DriverScreenMapView> {
  final _driverCtx = Get.put(DriverController());
  dynamic bearing;

  @override
  void initState() {
    super.initState();
    _driverCtx.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GoogleMap(
        onCameraMove: (position) {
          _driverCtx.driverBearing.value = position.bearing;
          _driverCtx.driverTarget.value = position.target;
          setState(() {});
        },
        compassEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: _driverCtx.driverLocation.value),
        onMapCreated: (GoogleMapController controller) {
          _driverCtx.googleMapController.value.complete(controller);
        },
        // markers: Set<Marker>.of(_driverCtx.markers.values),
        circles: _driverCtx.circles.value,
      ),
    );
  }
}
