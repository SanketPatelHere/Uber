
import 'package:aaa/utils/AssociateMethods.dart';
import 'package:app_settings/app_settings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../logging/logger_helper.dart';
import 'GoogleMapMethods.dart';
import 'package:geolocator/geolocator.dart';

/*
global class that import all class + make object only one time,
so in our page we just import this global class only
 */
AssociateMethods associateMethods = AssociateMethods();
//GoogleMapMethods googleMapMethods = GoogleMapMethods();

var myUserName = "";
var myUserPhone = "";

String googleMapKey = "AIzaSyCXB2gsB33hSm-HZnGqRk0leojAKLC7E2E";

const CameraPosition kGooglePlex1 = CameraPosition(
  //target: LatLng(37.42796133580664, -122.085749655962),
  target: LatLng(22.2832546, 70.7738741),
  zoom: 17,
);


Future<bool> handleLocationPermission() async {

  final TAG = "Myy main ";
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  TLoggerHelper.info("${TAG} user handleLocationPermission serviceEnabled = "+serviceEnabled.toString()); //true

  if (!serviceEnabled) {
    TLoggerHelper.info("${TAG} user handleLocationPermission Location services are disabled. Please enable the services");
    //TLoaders.customToast( message: "Location services are disabled. Please enable the services");
    //ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(content: Text('Location services are disabled. Please enable the services')));
    return false;
  }
  //else do nothing, location service permission granted

  permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied) {
      TLoggerHelper.info("${TAG} user handleLocationPermission Location permissions are denied");
      //TLoaders.customToast(message: "Location permissions are denied");
      //ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
      return false;
    }
    //else do nothing, Geolocator permission granted
  }
  if(permission == LocationPermission.deniedForever) {
    TLoggerHelper.info("${TAG} user handleLocationPermission Location permissions are deniedForever");
    //TLoaders.customToast(message: "Location permissions are permanently denied, we cannot request permissions.");
    //TLoaders.errorSnakeBar(title: "Error", message: "Location permissions are permanently denied, we cannot request permissions.");
    //ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')));
    Future.delayed(const Duration(seconds: 2),(){
      //Geolocator.openAppSettings(); //or
      //Geolocator.openLocationSettings(); //or
      ///AppSettings.openAppSettings(type: AppSettingsType.location); //or
      AppSettings.openAppSettings();
    });


    return false;
  }
  return true;
}
