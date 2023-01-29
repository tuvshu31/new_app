// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class Directions{

//   final List<PointLatLng> polylinePoints;
//   final String totalDistance;
//   final String totalDuration;
//   const Directions({

//     required this.polylinePoints,
//     required this.totalDistance, 
//     required this.totalDuration
//   })
//    Directions.fromJson(Map<String, dynamic> map, this.polylinePoints, this.totalDistance, this.totalDuration){
 
//     final data=Map<String, dynamic>.from(map["routes"][0]);
//     String distance="";
//     String duration="";


//   return Directions(polylinePoints: PolylinePoints().decodePolyline(data["overview_polyline"]["points"]), totalDistance: distance, totalDuration: duration,);

//   }
// }