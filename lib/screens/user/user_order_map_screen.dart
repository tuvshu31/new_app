import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
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

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> addCustomMarker() async {
    // BitmapDescriptor.fromAssetImage(
    //   const ImageConfiguration(),
    //   "assets/images/png/driver.png",
    // ).then((icon) {
    //   markerIcon = icon;
    //   LatLng position = _userCtx.markerPosition.value;
    //   // Marker marker = Marker(
    //   //   markerId: markerId,
    //   //   position: position,
    //   //   draggable: false,
    //   //   icon: markerIcon,
    //   // );
    // });
    MarkerId markerId = const MarkerId("marker");
    LatLng position = _userCtx.markerPosition.value;
    int iconSize = 100;
    if (Platform.isIOS) {
      iconSize = 85;
    }
    final Uint8List markerIcon =
        await getBytesFromAsset("assets/images/png/driver.png", iconSize);

    final Marker marker = Marker(
        markerId: markerId,
        position: position,
        draggable: false,
        icon: BitmapDescriptor.fromBytes(markerIcon));
    markers[markerId] = marker;
    setState(() {});
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
