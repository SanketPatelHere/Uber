import 'dart:async';

import 'package:aaa/utils/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utils/global.dart';

import 'controllers/CartController.dart';
import 'controllers/NotificationController.dart';
import 'logging/logger_helper.dart';
import 'screens/auth-ui/SignInScreen.dart';
import 'screens/widget/MyDrawerWidget.dart';
import 'services/NotificationService.dart';
import 'utils/app-constant.dart';
import 'package:get/get.dart';

//github demo user app = https://github.com/Warisalikhan786/EasyShopping/blob/main/lib/controllers/google-sign-in-controller.dart
//github demo admin app = https://github.com/Warisalikhan786/easy-shopping-admin-panel/blob/main/lib/screens/main-screen.dart
class MainScreen extends StatefulWidget {

  const MainScreen({super.key});


  @override
  State<StatefulWidget> createState() => _MainScreen();


}

class _MainScreen extends State<MainScreen> {
  final TAG = "Myy MainScreen ";
  NotificationService notificationService = NotificationService();
  NotificationController notificationController = Get.put(NotificationController());
  CartController cartController = Get.put(CartController()); //use only for get cart count
  double bottomPadding = 0;

  late Position currentPositionUser;
  final Completer<GoogleMapController> googleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;

  @override
  void initState()  {
    TLoggerHelper.info("${TAG} inside initState");
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    notificationService.firebaseInit(context); //initLocalNotification => //showNotification
    notificationService.setupInterfaceMessage(context); //handleMessage (for background and terminated app notifcation)
    ///FcmService.firebaseInit(); //now no need of this, because same use in notificationService.firebaseInit
  }

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text("Admin Panel"),
        actions: [
          GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAll(() => SignInScreen());
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      drawer: MyDrawerWidget(),
      body: GoogleMap(
          padding:EdgeInsets.only(top: 26,bottom: bottomPadding),
          mapType:MapType.normal,
          myLocationEnabled:true,
          initialCameraPosition: kGooglePlex1,
          onMapCreated:(GoogleMapController mapControlller)
          {
            controllerGoogleMap = mapControlller;
            googleMapCompleterController.complete(controllerGoogleMap);

            getCurrentLocation();
          },
      )
    );
  }



  getCurrentLocation() async{
    TLoggerHelper.info("${TAG} inside getCurrentLocation");

    Position userPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPositionUser = userPosition;
    //Latitude: 22.2832548, Longitude: 70.7738729
    TLoggerHelper.info("${TAG} getCurrentLocation currentPositionUser = "+currentPositionUser.toString());

    LatLng userLatlng = LatLng(currentPositionUser.latitude, currentPositionUser.longitude);
    //LatLng(22.2832546, 70.7738741)
    TLoggerHelper.info("${TAG} getCurrentLocation userLatlng = "+userLatlng.toString());

    CameraPosition positionCamera = CameraPosition(target: userLatlng, zoom:17,
      //bearing: currentPositionUser.heading
    );
    controllerGoogleMap!.animateCamera(CameraUpdate.newCameraPosition(positionCamera));

  }

}


class SalesData {
  SalesData(this.year, this.sales);
  final String year; //month
  final double sales;
}
