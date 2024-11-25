
import 'package:aaa/utils/AssociateMethods.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/*
global class that import all class + make object only one time,
so in our page we just import this global class only
 */
AssociateMethods associateMethods = AssociateMethods();

var myUserName = "";
var myUserPhone = "";

String googleMapKey = "AIzaSyCXB2gsB33hSm-HZnGqRk0leojAKLC7E2E";

const CameraPosition kGooglePlex1 = CameraPosition(
  //target: LatLng(37.42796133580664, -122.085749655962),
  target: LatLng(22.2832546, 70.7738741),
  zoom: 17,
);