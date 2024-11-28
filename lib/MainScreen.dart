import 'dart:async';

import 'package:aaa/appinfo/AppInfo.dart';
import 'package:aaa/utils/GoogleMapMethods.dart';
import 'package:aaa/utils/global.dart';
import 'package:aaa/utils/image_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  double searchContainerHeight = 230;

  late Position currentPositionUser;
  final Completer<GoogleMapController> googleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
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
      key: sKey,
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
      ///drawer: MyDrawerWidget(), //drawer 1
      //drawer 2
      drawer: SizedBox(
        width: 256,
        child: Drawer(
          backgroundColor:AppConstant.appSecondaryColor,
          child: ListView(
            children: [

              //header
              SizedBox(
                height: 160,
                child: DrawerHeader(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Row(
                      children: [
                        Image.asset(TImages.user, width: 60, height: 60),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Username ", style: TextStyle(color: AppConstant.appTextColor2, fontSize: 12, fontWeight: FontWeight.bold)),
                            SizedBox(width: 16),
                            Text("Profile ", style: TextStyle(color: AppConstant.appTextColor2, fontSize: 12, fontWeight: FontWeight.bold)),

                          ],
                        )
                      ],
                    )
                ),
              ),

              //body
              GestureDetector(
                onTap: ()async{
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>SignInScreen()));
                },
                child: const ListTile(
                  leading: Icon(Icons.history, color: Colors.white),
                  title: Text("History", style: TextStyle(color: AppConstant.appTextColor, fontSize: 12)),
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: const ListTile(
                  leading: Icon(Icons.info, color: Colors.white),
                  title: Text("About", style: TextStyle(color: AppConstant.appTextColor, fontSize: 12)),
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: const ListTile(
                  leading: Icon(Icons.logout, color: Colors.white),
                  title: Text("Logout", style: TextStyle(color: AppConstant.appTextColor, fontSize: 12)),
                ),
              ),

            ],
          ),
        ),
      ),
      body: Stack(
        children: [

          //Google map
          GoogleMap(
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
          ),

          //for drawer button show start
          Positioned(
              top:37,
              left: 20,
              child: GestureDetector(
                onTap: (){
                    sKey.currentState!.openDrawer();
               },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          spreadRadius: 0.5,
                          offset: Offset(0.7,0.7)
                        )
                      ],
                      //color: Colors.white),
                ),
                child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: Icon(Icons.menu, color: Colors.black,),
                 ),
              )
          ),
          ),
          //for drawer button show end


          //bottom search location container
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedSize(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 122),
                  child: Container(
                    //height: searchContainerHeight, //220
                    height: 200, //220
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(21),
                        topRight: Radius.circular(21),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                              children: [
                                    const Icon(Icons.location_on_outlined, color:Colors.grey),
                                    const SizedBox(width: 13),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          //const Text("From", style: TextStyle(fontSize: 12)),
                                          //Text("From", style: Theme.of(context).textTheme.labelMedium),
                                          Text("From", style: TextStyle(color: AppConstant.appTextColor2,fontSize: 12)),
                                          //const Text("jade blue, rajkot", style: TextStyle(fontSize: 12)),
                                          //Text("jade blue, rajkot", style: Theme.of(context).textTheme.labelMedium),
                                          //Text("jade blue, rajkot", style: TextStyle(color: AppConstant.appTextColor2,fontSize: 12)),
                                          Text(Provider.of<AppInfo>(context, listen: true).pickUpLocation==null
                                              ?"Please wait..."
                                              //:(Provider.of<AppInfo>(context, listen: false).pickUpLocation!.placeName!),
                                              :(Provider.of<AppInfo>(context, listen: false).pickUpLocation!.placeName!).substring(0,40)+"...",
                                              style: TextStyle(color: AppConstant.appTextColor2,fontSize: 12)),
                                        ],
                                    ),
                              ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(height: 1, thickness: 1,color: Colors.grey),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.location_pin, color:Colors.grey),
                              const SizedBox(width: 13),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("To", style: TextStyle(color: AppConstant.appTextColor2,fontSize: 12)),
                                  Text("Where to Go?", style: TextStyle(color: AppConstant.appTextColor2,fontSize: 12)),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          const Divider(height: 1, thickness: 1,color: Colors.grey),
                          const SizedBox(height: 10),

                          ElevatedButton(
                              onPressed: (){},
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              child: const Text(" Select Destination ",
                                style: TextStyle(color:Colors.white),
                              )
                          )
                        ],
                      ),
                    ),

                  ),
              ),

          ),
        ],

      )


    );
  }



  getCurrentLocation() async{
    TLoggerHelper.info("${TAG} inside getCurrentLocation");


    //for ask location permission start
    /*final hasPermission = await handleLocationPermission();
    TLoggerHelper.info("${TAG} hasPermission = "+hasPermission.toString());
    if(!hasPermission) {
      //return;
      //agian ask permission
      LocationPermission permission = await Geolocator.requestPermission();
    }*/
    //for ask location permission end

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


    //for get address from lat,long start
    //direct get address without api calling, using geocoding , no need of key start
    //List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    //giving list of 5 places
    //TLoggerHelper.info("${TAG} getAddressFromLatLngFree placemarks = "+placemarks.toString());
    GoogleMapMethods.getAddressFromLatLngExactFree(context, currentPositionUser);
    //direct get address without api calling, using geocoding , no need of key end
    //or
    GoogleMapMethods.getAddressFromLatLngNearest(currentPositionUser.latitude, currentPositionUser.longitude);
    //or
    GoogleMapMethods.convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(currentPositionUser, context);
    //for get address from lat,long end




  }


}


class SalesData {
  SalesData(this.year, this.sales);
  final String year; //month
  final double sales;
}
