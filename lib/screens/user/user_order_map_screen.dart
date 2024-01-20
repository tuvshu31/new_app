import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserOrderMapScreen extends StatefulWidget {
  int orderId;
  UserOrderMapScreen({required this.orderId, super.key});

  @override
  State<UserOrderMapScreen> createState() => _UserOrderMapScreenState();
}

class _UserOrderMapScreenState extends State<UserOrderMapScreen> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final _userCtx = Get.put(UserController());
  @override
  void initState() {
    super.initState();
    addCustomMarker();
    log(widget.orderId.toString());
    _userCtx.getDriverPositionStream(widget.orderId);
  }

  void addCustomMarker() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/png/driver.png",
    ).then((icon) {
      markerIcon = icon;
      MarkerId markerId = const MarkerId("marker");
      LatLng position = _userCtx.markerPosition.value;
      Marker marker = Marker(
        markerId: markerId,
        position: position,
        draggable: false,
        icon: markerIcon,
      );
      markers[markerId] = marker;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _userCtx.googleMapController = Completer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: Get.height * .6,
          child: GoogleMap(
            scrollGesturesEnabled: false,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: false,
            mapType: MapType.normal,
            buildingsEnabled: true,
            myLocationButtonEnabled: true,
            onCameraMove: (position) {
              if (markers.isNotEmpty) {
                MarkerId markerId = const MarkerId("marker");
                Marker? marker = markers[markerId];
                Marker updatedMarker = marker!.copyWith(
                  positionParam: position.target,
                );
                markers[markerId] = updatedMarker;
              }
              setState(() {});
            },
            rotateGesturesEnabled: true,
            trafficEnabled: false,
            compassEnabled: false,
            markers: Set<Marker>.of(markers.values),
            initialCameraPosition: CameraPosition(
              target: _userCtx.markerPosition.value,
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
              if (!_userCtx.googleMapController.isCompleted) {
                _userCtx.googleMapController.complete(controller);
              }
            },
          ),
        ),
      ],
    );
  }
}
