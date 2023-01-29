import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

CameraPosition _camera(lat, lng, tilted) {
  return CameraPosition(
    target: LatLng(lat, lng),
    zoom: 16.5,
    tilt: tilted ? 80 : 0,
  );
}

GoogleMap googleMap(mapCTRL, lat1, lng1, lat2, lng2) {
  return GoogleMap(
    markers: {
      Marker(
        markerId: const MarkerId("source"),
        position: LatLng(lat1, lng1),
        draggable: true,
        onDragEnd: (value) {
          // value is the new position
        },
      ),
      Marker(
        markerId: const MarkerId("destination"),
        position: LatLng(lat2, lng2),
        draggable: true,
        onDragEnd: (value) {
          // value is the new position
        },
        // icon: destinationMarker,
      ),
    },
    mapType: MapType.normal,
    initialCameraPosition: _camera(lat1, lng2, false),
    onMapCreated: (GoogleMapController controller) {
      mapCTRL.complete(controller);
    },
  );
}

Widget timer(active, duration) {
  String strDigits(int n) => n.toString().padLeft(2, '0');
  final hours = strDigits(duration.inHours.remainder(60));
  final minutes = strDigits(duration.inMinutes.remainder(60));
  final seconds = strDigits(duration.inSeconds.remainder(60));
  return active
      ? Positioned(
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: const BoxDecoration(color: MyColors.white),
            child: CustomText(
              text: "$hours:$minutes:$seconds",
              color: MyColors.primary,
              fontSize: 12,
            ),
          ),
        )
      : Container();
}

PreferredSize appBar(active, onSwitch) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(54.0),
    child: AppBar(
      iconTheme: const IconThemeData(color: MyColors.primary),
      backgroundColor: MyColors.white,
      elevation: 0,
      centerTitle: true,
      titleSpacing: 0,
      title: CustomText(
        text: active ? "Online" : "Offline",
        color: MyColors.black,
        fontSize: 16,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: CupertinoSwitch(
            value: active,
            thumbColor: active ? MyColors.primary : MyColors.gray,
            trackColor: MyColors.background,
            activeColor: MyColors.black,
            onChanged: onSwitch,
          ),
        ),
      ],
    ),
  );
}
