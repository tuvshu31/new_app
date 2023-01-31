import 'dart:async';
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
  @override
  void initState() {
    super.initState();
    addMarker();
  }

  Set<Marker> markers = Set();
  void addMarker() async {
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/png/app/address.png",
    );
    markers.add(Marker(
      markerId: MarkerId("origin"),
      position: _driverCtx.origin.value,
      icon: markerbitmap, //Icon for Marker
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _driverCtx.origin.value,
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              _driverCtx.googleMapController.value.complete(controller);
            },
            markers: markers,
          ),
        ],
      )),
    );
  }
}
