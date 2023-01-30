import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
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
            polylines: {
              // Polyline(
              //     polylineId: const PolylineId("poliline_overview"),
              //     color: MyColors.primary,
              //     width: 7,
              //     points: _driverCtx.polylinePoints
              //         .map((element) =>
              //             LatLng(element.latitude, element.longitude))
              //         .toList())
            },
            markers: {
              Marker(
                markerId: MarkerId("origin"),
                position: _driverCtx.origin.value,
                draggable: false,
              ),
              // Marker(
              //   markerId: MarkerId("destination"),
              //   position: _driverCtx.destination.value,
              //   draggable: false,
              // ),
            },
          ),
        ],
      )),
    );
  }
}
