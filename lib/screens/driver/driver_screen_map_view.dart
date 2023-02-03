import 'dart:developer';

import 'package:geolocator/geolocator.dart';
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
  dynamic driverMarker;
  dynamic storeMarker;
  Set<Marker> markers = {};
  @override
  void initState() {
    super.initState();
    addInitialMarker();
  }

  void addInitialMarker() async {
    var info = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    _driverCtx.driverLat.value = info.latitude;
    _driverCtx.driverLng.value = info.longitude;
    addDriverMarker();
    BitmapDescriptor storebitmap = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/png/app/store.png",
    );
    setState(() {
      storeMarker = storebitmap;
    });
  }

  void addDriverMarker() async {
    BitmapDescriptor driverbitmap = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/png/app/address.png",
    );
    markers.add(Marker(
      markerId: const MarkerId("origin"),
      position: LatLng(_driverCtx.driverLat.value, _driverCtx.driverLng.value),
      icon: driverbitmap, //Icon for Marker
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
              target: LatLng(
                  _driverCtx.driverLat.value, _driverCtx.driverLng.value)),
          onMapCreated: (GoogleMapController controller) {
            _driverCtx.googleMapController.value.complete(controller);
          },
          markers: {
            ...markers,
            _driverCtx.deliveryRequest.value
                ? Marker(
                    markerId: const MarkerId("store"),
                    position: LatLng(
                        _driverCtx.storeLat.value, _driverCtx.storeLng.value),
                    icon: storeMarker, //Icon for Marker
                  )
                : Marker(markerId: MarkerId("store"))
          }),
    );
  }
}
