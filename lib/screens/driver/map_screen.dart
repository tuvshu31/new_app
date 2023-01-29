import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final _driverCtx = Get.put(DriverController());
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    _goToDriversLocation();
    _driverCtx.determineUsersPosition();
    _driverCtx.calculateDistance();
  }

  void _goToDriversLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _driverCtx.origin.value, zoom: 16)));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _driverCtx.hasMapData.value
            ? Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: _driverCtx.origin.value,
                      zoom: 14,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    polylines: {
                      Polyline(
                          polylineId: const PolylineId("poliline_overview"),
                          color: MyColors.primary,
                          width: 7,
                          points: _driverCtx.polylinePoints
                              .map((element) =>
                                  LatLng(element.latitude, element.longitude))
                              .toList())
                    },
                    markers: {
                      Marker(
                        markerId: MarkerId("origin"),
                        position: _driverCtx.origin.value,
                        draggable: false,
                      ),
                      Marker(
                        markerId: MarkerId("destination"),
                        position: _driverCtx.destination.value,
                        draggable: false,
                      ),
                    },
                  ),
                  Container(
                    color: MyColors.primary,
                    width: double.infinity,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomText(text: _driverCtx.duration.toString()),
                        CustomText(text: _driverCtx.distance.toString()),
                      ],
                    ),
                  ),
                ],
              )
            : const Center(
                child: CustomText(text: "Түр хүлээнэ үү..."),
              ),
      ),
    );
  }
}
