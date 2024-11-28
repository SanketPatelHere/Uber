import 'package:aaa/utils/TLoaders.dart';
import 'package:aaa/utils/global.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'appinfo/AppInfo.dart';
import 'firebase_options.dart';
import 'logging/logger_helper.dart';
import 'screens/auth-ui/SplashScreen.dart';
import 'theme/theme.dart';
import 'utils/helper_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:platform_device_id/platform_device_id.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

/*
return Scaffold
body SafeArea

SafeArea = screen top and bottom color(statusbar) not change, not affected
when some design issue occur then use outer Scaffold and inner SafeArea
outside of Column - SizedBox, Padding, Container, Stack, Card, ListView, SingleChildScrollView or Expanded, Flexible
SizedBox = widget use for giving constant width or height between two widgets,
SizedBox(height:10), it does not cotain any decorative properties just like color, borderRadius

Container = widget use for specific size constraint, width,height change
we can modify according by our need
it provide option for styling or decoration. you can set properties like color,decoration,
padding,margin,border of container and its child

Expanded takes all available space like match_parent, change using flex factor
Flexible takes only needed space like wrap_content, change using fit parameter
 */
//main()=>AuthenticationRepository, MyApp=>NavigationMenu


@pragma('vm:entry-point') //main for firebase notification background message get
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async{
  final TAG = "Myy main ";
  WidgetsFlutterBinding.ensureInitialized();
  ///Firebase.initializeApp();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  /*await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
          (FirebaseApp value) => Get.put(AuthenticationRepository())
   );*/

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  TLoggerHelper.info("${TAG} build called");

    //for ask location permission start
    final hasPermission = await handleLocationPermission();
    TLoggerHelper.info("${TAG} hasPermission = "+hasPermission.toString());
    if(!hasPermission) {
      //return;
      //agian ask permission
      LocationPermission permission = await Geolocator.requestPermission();
    }
    //or
    await Permission.locationWhenInUse.isDenied.then((value) async{
      TLoggerHelper.info("${TAG} Permission locationWhenInUse value = "+value.toString());
      //when location Permission not granted
      if(value){
        //come into this when not location permission
        TLoggerHelper.info("${TAG} Permission locationWhenInUse inside if value = "+value.toString());
        Permission.locationWhenInUse.request();
      }
      else{
        TLoggerHelper.info("${TAG} Permission locationWhenInUse inside else value = "+value.toString());
      }
    });
    //for ask location permission end


    runApp(const MyApp());

}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  /*const MyApp({super.key, this.child});
  final Widget? child;
  static void restartApp(BuildContext context){
    //for every time ui,widget refresh when some data change
    context.findAncestorStateOfType<_MyAppState>()!.restartApp(); //This method is useful for changing the state of an ancestor widget in a one-off manner
  }*/

  @override
  State<MyApp> createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {
  final TAG = "Myy MyApp ";

  bool _isSignedIn = false;
  @override
  void initState() {
    getUserLoggedInstatus();
    subscribeForNotification();
    super.initState();
  }

  /*Key key = UniqueKey();
  void restartApp(){
      setState(() {
        key = UniqueKey();
      });
  }
  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} build called");
    //[#0b413]
    TLoggerHelper.info("${TAG} key = "+key.toString()); //[#0a826]

    return KeyedSubtree(key:key, child: widget.child!,);
  }*/


  //use it in another class
  getUserLoggedInstatus() async{
    await THelperFunctions.getUserLoggedInstatus().then((value){
      if(value!=null){
        _isSignedIn = value;
        TLoggerHelper.info("${TAG} getUserLoggedInstatus _isSignedIn = "+_isSignedIn.toString());
      }
    });
  }






  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context); //for change color(light,dark) as per user's theme
    TLoggerHelper.info("${TAG} build called");


    //todo for save in firestore database start
    //String dateString = DateTime.now().toString();
    //FirebaseFirestore.instance.collection('users').add({'text': 'data added through app'+dateString});
    //todo for save in firestore database end

    //todo for save in realtime database start
    saveAppOpenLoginInFirebase();
    //todo for save in realtime database end

    //return MaterialApp(
    return ChangeNotifierProvider(
      create:(context)=>AppInfo(), //for change ui when address change
      child: GetMaterialApp(
        title: 'Ecomm',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        home: SplashScreen(),
        ///home: SignInScreen(),
        //home: SignUpScreen(),
        ///home: WelcomeScreen(),
        builder: EasyLoading.init(),
        ///home:_isSignedIn?const HomeScreen(): LoginScreen(),
        navigatorKey: Get.key,
      ),
    );

  }

  void subscribeForNotification(){
    //for send push notification to all users(group wise send)
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic("all");
    TLoggerHelper.info("${TAG} subscribeForNotification working");

  }



  Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build) {
    print(build.id);
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      //'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  void saveAppOpenLoginInFirebase() async
  {
    //todo For save user data in firebase realtime database start
    TLoggerHelper.info("${TAG} googleSignIn save data in firebase");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    /*if(Platform.isAndroid) {
        deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      }*/
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    TLoggerHelper.info("${TAG} save data in firebase deviceInfo = "+deviceInfo.toString());
    TLoggerHelper.info("${TAG} save data in firebase androidInfo = "+androidInfo.toString()); //BaseDeviceInfo{data: {product: m20ltedd, supportedAbis: [arm64-v8a, armeabi-v7a, armeabi], serialNumber: unknown, displayMetrics: {xDpi: 307.0, widthPx: 810.0, heightPx: 1755.0, yDpi: 307.0}, supported32BitAbis: [armeabi-v7a, armeabi], display: QP1A.190711.020.M205FDDS9CWA2, type: user, isPhysicalDevice: true, version: {baseOS: samsung/m20ltedd/m20lte:10/QP1A.190711.020/M205FDDU8CVG4:user/release-keys, securityPatch: 2023-02-01, sdkInt: 29, release: 10, codename: REL, previewSdkInt: 0, incremental: M205FDDS9CWA2}, systemFeatures: [android.hardware.sensor.proximity, com.samsung.android.sdk.camera.processor, com.sec.feature.motionrecognition_service, android.hardware.sensor.accelerometer, android.hardware.faketouch, android.hardware.usb.accessory, android.software.backup, android.hardware.touchscreen, android.hardware.touchscreen.multitouch, android.software.print, android.software.activities_on_secondary_displays, com.samsung.feat

    //var deviceData = androidInfo.toMap();
    //TLoggerHelper.info("${TAG} googleSignIn save data in firebase deviceData = "+deviceData.toString()); //{product: m20ltedd, supportedAbis: [arm64-v8a,
    var deviceData2 = readAndroidBuildData(await deviceInfo.androidInfo);
    var manufacturer = androidInfo.manufacturer;
    var model = androidInfo.model;
    var sdkInt = androidInfo.version.sdkInt;
    var release = androidInfo.version.release;
    var deviceData3 = "Android $release (SDK $sdkInt) $manufacturer $model";
    TLoggerHelper.info("${TAG} googleSignIn save data in firebase deviceData2 = "+deviceData2.toString()); //{version.securityPatch: 2023-02-01, version.sdkInt: 29, version.release: 10, version.previewSdkInt: 0, version.incremental: M205FDDS9CWA2, version.codename: REL, version.baseOS: samsung/m20ltedd/m20lte:10/QP1A.190711.020/M205FDDU8CVG4:user/release-keys, board: exynos7904, bootloader: M205FDDS9CWA2, brand: samsung, device: m20lte, display: QP1A.190711.020.M205FDDS9CWA2, fingerprint: samsung/m20ltedd/m20lte:10/QP1A.190711.020/M205FDDS9CWA2:user/release-keys, hardware: exynos7904, host: SWDJ5004, id: QP1A.190711.020, manufacturer: samsung, model: SM-M205F, product: m20ltedd, supported32BitAbis: [armeabi-v7a, armeabi], supported64BitAbis: [arm64-v8a], supportedAbis: [arm64-v8a, armeabi-v7a, armeabi], tags: release-keys, type: user, isPhysicalDevice: true, systemFeatures: [android.hardware.sensor.proximity, com.samsung.android.sdk.camera.processor, com.sec.feature.motionrecognition_service, android.hardware.sensor.accele
    TLoggerHelper.info("${TAG} googleSignIn save data in firebase deviceData3 = $deviceData3"); //Android 10 (SDK 29), samsung SM-M205F
    //var myuuid = await PlatformDeviceId.getDeviceId;
    var myuuid = "";
    TLoggerHelper.info("${TAG} googleSignIn save data in firebase myuuid = $myuuid");
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    TLoggerHelper.info("${TAG} googleSignIn save data in firebase deviceToken = $deviceToken");


    /*final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
      var build2 = await deviceInfoPlugin.androidInfo;
      var uuid = build2.androidId;
      var data = await deviceInfoPlugin.iosInfo;
      var uuid2 = data.identifierForVendor;
      var uuid3 = await PlatformDeviceId.getDeviceId;*/

    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy'); //08-05-2024
    String formattedDate = formatter.format(now);
    var formattedTime = DateFormat('hh:mm:ss a').format(DateTime.now()); //12:37:04 PM
    TLoggerHelper.info("${TAG} save data in firebase formattedDate = "+formattedDate.toString()); //08-05-2024
    TLoggerHelper.info("${TAG} save data in firebase formattedTime = "+formattedTime.toString()); //12:37:04 PM


    //error = No implementation found for method getAll on channel dev.fluttercommunity.plus/package_info
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    String appName = packageInfo.appName;
    String buildNumber = packageInfo.buildNumber;
    String appversion = packageInfo.version;
    TLoggerHelper.info("${TAG} save data in firebase packageName = "+packageName); //com.example.aaa
    TLoggerHelper.info("${TAG} save data in firebase appName = "+appName); //Wemake New Library
    TLoggerHelper.info("${TAG} save data in firebase buildNumber = "+buildNumber); //1
    TLoggerHelper.info("${TAG} save data in firebase appversion = "+appversion); //1.0.0


    var database = FirebaseDatabase.instance;
    DatabaseReference databaseReference;
    //databaseReference = FirebaseDatabase.instance.ref().child('ECommerce App User').child(deviceData3).child(deviceData3+"__"+formattedDate+"__"+formattedTime); //or
    //databaseReference = FirebaseDatabase.instance.ref('ECommerce App User Login').child(deviceData3).child(deviceData3+"__"+formattedDate+"__"+formattedTime);
    databaseReference = FirebaseDatabase.instance.ref('ECommerce App open').child(deviceData3);
    databaseReference.child("lastDate").set(formattedDate); //08-05-2024
    databaseReference.child("lastTime").set(formattedTime); //04:34:54 PM
    //user device info
    databaseReference.child("deviceFullData").set(deviceData2.toString());
    databaseReference.child("deviceInfo").set(deviceData3.toString());
    databaseReference.child("deviceUUID").set(myuuid.toString());
    databaseReference.child("deviceToken").set(deviceToken.toString());
    //user app info
    databaseReference.child("apppackageName").set(packageName); //com.example.aaa
    databaseReference.child("appName").set(appName); //Wemake New Library
    databaseReference.child("appbuildNumber").set(buildNumber); //1
    databaseReference.child("appversion").set(appversion); //1.0.0
    //user info
    //databaseReference.child("email").set(email.text.trim()); //aa@aa.com
    //databaseReference.child("password").set(password.text.trim()); //1111
    //(user.id).set(user.toJson())


    //for delete all users from authentication in firebase
    //FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
    //FirebaseFirestore.instance.collection('users').doc().delete();

    //todo For save user data in firebase realtime database end




  }



}


/*
Flutter 3.24.5 • channel stable • https://github.com/flutter/flutter.git
Framework • revision dec2ee5c1f (13 days ago) • 2024-11-13 11:13:06 -0800
Engine • revision a18df97ca5
Tools • Dart 3.5.4 • DevTools 2.37.3
 */