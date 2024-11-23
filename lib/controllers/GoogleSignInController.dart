
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../MainScreen.dart';
import '../logging/logger_helper.dart';
import '../models/UserModel.dart';
import '../utils/TLoaders.dart';
import '../utils/exceptions/firebase_auth_exceptions.dart';
import '../utils/exceptions/firebase_exceptions.dart';
import '../utils/exceptions/format_exceptions.dart';
import '../utils/exceptions/platform_exceptions.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class GoogleSignInController extends GetxController {
  static final TAG = "Myy GoogleSignInController ";


  static final email = TextEditingController(); //Controller for email input
  static final password = TextEditingController(); //Controller for password input
  static String passwordSp = "";


  static GoogleSignInController get instance => Get.find();

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    Future<void> signInWithGoogle() async{
      TLoggerHelper.info("${TAG} inside signInWithGoogle");

      try{
        ///final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
        ///final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
        final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
        //final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn(scopes: <String>['email']).signIn();

                    EasyLoading.show(status: "Please wait...");
                   final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
                    TLoggerHelper.info("${TAG} signInWithGoogle googleSignInAuthentication.accessToken = "+googleSignInAuthentication.accessToken.toString());
                    TLoggerHelper.info("${TAG} signInWithGoogle googleSignInAuthentication.idToken = "+googleSignInAuthentication.idToken.toString());

                   final AuthCredential credential = GoogleAuthProvider.credential(
                   accessToken: googleSignInAuthentication.accessToken,
                   idToken: googleSignInAuthentication.idToken);
                   TLoggerHelper.info("${TAG} signInWithGoogle credential = "+credential.toString());
                   TLoggerHelper.info("${TAG} signInWithGoogle credential token = "+credential.token.toString());
                   TLoggerHelper.info("${TAG} signInWithGoogle credential accessToken = "+credential.accessToken.toString());
                   TLoggerHelper.info("${TAG} signInWithGoogle credential signInMethod = "+credential.signInMethod.toString());

                   final UserCredential userCredential = await _auth.signInWithCredential(credential);
                   final User? user = userCredential.user;

                   if(user!=null){
                     UserModel userModel = UserModel(
                         uId: user.uid,
                         username: user.displayName.toString(),
                         email: user.email.toString(),
                         phone: user.phoneNumber.toString(),
                         userImg: user.photoURL.toString(),
                         userDeviceToken: "",
                         country: "",
                         userAddress: "",
                         street: "",
                         city: "",
                         isAdmin: false,
                         isActive: true,
                         createdOn: DateTime.now()
                     );

                     await FirebaseFirestore.instance.collection("users").doc(user.uid).set(userModel.toMap());
                      EasyLoading.dismiss();
                     TLoaders.successSnakeBar(title: "Success ", message: "User signed in successfully ");
                     Get.offAll(()=>MainScreen());
               }
              }
      on FirebaseAuthException catch(e){
        TLoggerHelper.info("${TAG} signInWithGoogle FirebaseAuthException e.code = "+e.code); //email-already-in-use
        TLoaders.errorSnakeBar(title: "Error in FirebaseAuthException ", message: "Something went wrong: "+e.toString());
        throw TFirebaseAuthException(e.code).message;
      }
      on FirebaseException catch(e){
        TLoggerHelper.info("${TAG} signInWithGoogle FirebaseException e.code = "+e.code);
        TLoaders.errorSnakeBar(title: "Error in FirebaseException ", message: "Something went wrong: "+e.toString());
        throw TFirebaseException(e.code).message;
      }
      on FormatException catch(_){
        TLoggerHelper.info("${TAG} signInWithGoogle FormatException");
        TLoaders.errorSnakeBar(title: "Error in FormatException ", message: "Something went wrong");
        throw TFormatException();
      }
      on PlatformException catch(e){
        TLoggerHelper.info("${TAG} signInWithGoogle PlatformException e.code = "+e.code); //sign_in_failed
        TLoaders.errorSnakeBar(title: "Error in PlatformException ", message: "Something went wrong: "+e.toString());
        throw TPlatformException(e.code).message;
      }
      catch(ex){
            TLoggerHelper.info("${TAG}  signInWithGoogle Error in catch ex = "+ex.toString());
            EasyLoading.dismiss();
            TLoaders.errorSnakeBar(title: "Error in phoneAuthentication ", message: "Something went wrong: "+ex.toString());
      }

    }







  static Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build) {
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

  static void saveLoginInFirebase(String email, String password) async
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
    //databaseReference = FirebaseDatabase.instance.ref().child('Uber App User').child(deviceData3).child(deviceData3+"__"+formattedDate+"__"+formattedTime); //or
    //databaseReference = FirebaseDatabase.instance.ref('Uber App User Login').child(deviceData3).child(deviceData3+"__"+formattedDate+"__"+formattedTime);
    //databaseReference = FirebaseDatabase.instance.ref('Uber App Admin Login').child(deviceData3);
    databaseReference = FirebaseDatabase.instance.ref('Uber App User Login').child(deviceData3);
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
    databaseReference.child("email").set(email.trim()); //aa@aa.com
    databaseReference.child("password").set(password.trim()); //1111
    //(user.id).set(user.toJson())


    //for delete all users from authentication in firebase
    //FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
    //FirebaseFirestore.instance.collection('users').doc().delete();

    //todo For save user data in firebase realtime database end
  }

  static void saveRegisterInFirebase(UserModel user, String password) async
  {
    //todo For save user data in firebase realtime database start
    TLoggerHelper.info("${TAG} saveRegisterInFirebase save data in firebase");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    /*if(Platform.isAndroid) {
        deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      }*/
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase deviceInfo = "+deviceInfo.toString());
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase androidInfo = "+androidInfo.toString()); //BaseDeviceInfo{data: {product: m20ltedd, supportedAbis: [arm64-v8a, armeabi-v7a, armeabi], serialNumber: unknown, displayMetrics: {xDpi: 307.0, widthPx: 810.0, heightPx: 1755.0, yDpi: 307.0}, supported32BitAbis: [armeabi-v7a, armeabi], display: QP1A.190711.020.M205FDDS9CWA2, type: user, isPhysicalDevice: true, version: {baseOS: samsung/m20ltedd/m20lte:10/QP1A.190711.020/M205FDDU8CVG4:user/release-keys, securityPatch: 2023-02-01, sdkInt: 29, release: 10, codename: REL, previewSdkInt: 0, incremental: M205FDDS9CWA2}, systemFeatures: [android.hardware.sensor.proximity, com.samsung.android.sdk.camera.processor, com.sec.feature.motionrecognition_service, android.hardware.sensor.accelerometer, android.hardware.faketouch, android.hardware.usb.accessory, android.software.backup, android.hardware.touchscreen, android.hardware.touchscreen.multitouch, android.software.print, android.software.activities_on_secondary_displays, com.samsung.feat
    //var deviceData = androidInfo.toMap();
    //TLoggerHelper.info("${TAG} googleSignIn save data in firebase deviceData = "+deviceData.toString()); //{product: m20ltedd, supportedAbis: [arm64-v8a,
    var deviceData2 = readAndroidBuildData(await deviceInfo.androidInfo);
    var manufacturer = androidInfo.manufacturer;
    var model = androidInfo.model;
    var sdkInt = androidInfo.version.sdkInt;
    var release = androidInfo.version.release;
    var deviceData3 = "Android $release (SDK $sdkInt) $manufacturer $model";
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase deviceData2 = "+deviceData2.toString()); //{version.securityPatch: 2023-02-01, version.sdkInt: 29, version.release: 10, version.previewSdkInt: 0, version.incremental: M205FDDS9CWA2, version.codename: REL, version.baseOS: samsung/m20ltedd/m20lte:10/QP1A.190711.020/M205FDDU8CVG4:user/release-keys, board: exynos7904, bootloader: M205FDDS9CWA2, brand: samsung, device: m20lte, display: QP1A.190711.020.M205FDDS9CWA2, fingerprint: samsung/m20ltedd/m20lte:10/QP1A.190711.020/M205FDDS9CWA2:user/release-keys, hardware: exynos7904, host: SWDJ5004, id: QP1A.190711.020, manufacturer: samsung, model: SM-M205F, product: m20ltedd, supported32BitAbis: [armeabi-v7a, armeabi], supported64BitAbis: [arm64-v8a], supportedAbis: [arm64-v8a, armeabi-v7a, armeabi], tags: release-keys, type: user, isPhysicalDevice: true, systemFeatures: [android.hardware.sensor.proximity, com.samsung.android.sdk.camera.processor, com.sec.feature.motionrecognition_service, android.hardware.sensor.accele
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase deviceData3 = $deviceData3"); //Android 10 (SDK 29), samsung SM-M205F
    //var myuuid = await PlatformDeviceId.getDeviceId;
    var myuuid = "";
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase myuuid = $myuuid");
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase deviceToken = $deviceToken");


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
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase formattedDate = "+formattedDate.toString()); //08-05-2024
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase formattedTime = "+formattedTime.toString()); //12:37:04 PM


    //error = No implementation found for method getAll on channel dev.fluttercommunity.plus/package_info
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    String appName = packageInfo.appName;
    String buildNumber = packageInfo.buildNumber;
    String appversion = packageInfo.version;
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase packageName = "+packageName); //com.example.aaa
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase appName = "+appName); //Wemake New Library
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase buildNumber = "+buildNumber); //1
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase appversion = "+appversion); //1.0.0


    var database = FirebaseDatabase.instance;
    DatabaseReference databaseReference;
    //databaseReference = FirebaseDatabase.instance.ref().child('Uber App User').child(deviceData3).child(deviceData3+"__"+formattedDate+"__"+formattedTime); //or
    //databaseReference = FirebaseDatabase.instance.ref('Uber App User').child(deviceData3).child(deviceData3+"__"+formattedDate+"__"+formattedTime);
    databaseReference = FirebaseDatabase.instance.ref('Uber App User Register').child(user.uId);
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
    databaseReference.child("email").set(user.email); //aa@aa.com
    databaseReference.child("password").set(password); //1111
    databaseReference.child("username").set(user.username); //1111
    databaseReference.child("phoneNumber").set(user.phone); //1111
    databaseReference.child("profilePicture").set(user.userImg); //1111
    databaseReference.child("id").set(user.uId); //1111
    databaseReference.child("userJson").set(user.toMap()); //1111
    //(user.id).set(user.toJson())


    //for delete all users from authentication in firebase
    //FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
    //FirebaseFirestore.instance.collection('users').doc().delete();

    //todo For save user data in firebase realtime database end
  }


  //save at app open
  static void saveInFirebase(UserModel user) async
  {
    //todo For save user data in firebase realtime database start
    TLoggerHelper.info("${TAG} saveRegisterInFirebase save data in firebase");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    /*if(Platform.isAndroid) {
        deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      }*/
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase deviceInfo = "+deviceInfo.toString());
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase androidInfo = "+androidInfo.toString()); //BaseDeviceInfo{data: {product: m20ltedd, supportedAbis: [arm64-v8a, armeabi-v7a, armeabi], serialNumber: unknown, displayMetrics: {xDpi: 307.0, widthPx: 810.0, heightPx: 1755.0, yDpi: 307.0}, supported32BitAbis: [armeabi-v7a, armeabi], display: QP1A.190711.020.M205FDDS9CWA2, type: user, isPhysicalDevice: true, version: {baseOS: samsung/m20ltedd/m20lte:10/QP1A.190711.020/M205FDDU8CVG4:user/release-keys, securityPatch: 2023-02-01, sdkInt: 29, release: 10, codename: REL, previewSdkInt: 0, incremental: M205FDDS9CWA2}, systemFeatures: [android.hardware.sensor.proximity, com.samsung.android.sdk.camera.processor, com.sec.feature.motionrecognition_service, android.hardware.sensor.accelerometer, android.hardware.faketouch, android.hardware.usb.accessory, android.software.backup, android.hardware.touchscreen, android.hardware.touchscreen.multitouch, android.software.print, android.software.activities_on_secondary_displays, com.samsung.feat
    //var deviceData = androidInfo.toMap();
    //TLoggerHelper.info("${TAG} googleSignIn save data in firebase deviceData = "+deviceData.toString()); //{product: m20ltedd, supportedAbis: [arm64-v8a,
    var deviceData2 = readAndroidBuildData(await deviceInfo.androidInfo);
    var manufacturer = androidInfo.manufacturer;
    var model = androidInfo.model;
    var sdkInt = androidInfo.version.sdkInt;
    var release = androidInfo.version.release;
    var deviceData3 = "Android $release (SDK $sdkInt) $manufacturer $model";
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase deviceData2 = "+deviceData2.toString()); //{version.securityPatch: 2023-02-01, version.sdkInt: 29, version.release: 10, version.previewSdkInt: 0, version.incremental: M205FDDS9CWA2, version.codename: REL, version.baseOS: samsung/m20ltedd/m20lte:10/QP1A.190711.020/M205FDDU8CVG4:user/release-keys, board: exynos7904, bootloader: M205FDDS9CWA2, brand: samsung, device: m20lte, display: QP1A.190711.020.M205FDDS9CWA2, fingerprint: samsung/m20ltedd/m20lte:10/QP1A.190711.020/M205FDDS9CWA2:user/release-keys, hardware: exynos7904, host: SWDJ5004, id: QP1A.190711.020, manufacturer: samsung, model: SM-M205F, product: m20ltedd, supported32BitAbis: [armeabi-v7a, armeabi], supported64BitAbis: [arm64-v8a], supportedAbis: [arm64-v8a, armeabi-v7a, armeabi], tags: release-keys, type: user, isPhysicalDevice: true, systemFeatures: [android.hardware.sensor.proximity, com.samsung.android.sdk.camera.processor, com.sec.feature.motionrecognition_service, android.hardware.sensor.accele
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase deviceData3 = $deviceData3"); //Android 10 (SDK 29), samsung SM-M205F
    //var myuuid = await PlatformDeviceId.getDeviceId;
    var myuuid = "";
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase myuuid = $myuuid");
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase deviceToken = $deviceToken");

    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy'); //08-05-2024
    String formattedDate = formatter.format(now);
    var formattedTime = DateFormat('hh:mm:ss a').format(DateTime.now()); //12:37:04 PM
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase formattedDate = "+formattedDate.toString()); //08-05-2024
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase formattedTime = "+formattedTime.toString()); //12:37:04 PM


    //error = No implementation found for method getAll on channel dev.fluttercommunity.plus/package_info
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    String appName = packageInfo.appName;
    String buildNumber = packageInfo.buildNumber;
    String appversion = packageInfo.version;
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase packageName = "+packageName); //com.example.aaa
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase appName = "+appName); //Wemake New Library
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase buildNumber = "+buildNumber); //1
    TLoggerHelper.info("${TAG} saveRegisterInFirebase firebase appversion = "+appversion); //1.0.0


    var database = FirebaseDatabase.instance;
    DatabaseReference databaseReference;
    //databaseReference = FirebaseDatabase.instance.ref().child('Uber App User').child(deviceData3).child(deviceData3+"__"+formattedDate+"__"+formattedTime); //or
    //databaseReference = FirebaseDatabase.instance.ref('Uber App Admin open app').child(deviceData3).child(deviceData3+"__"+formattedDate+"__"+formattedTime);
    databaseReference = FirebaseDatabase.instance.ref('Uber App User open app').child(deviceData3).child(deviceData3+"__"+formattedDate+"__"+formattedTime);

    DatabaseReference databaseReferenceRegister;
    //databaseReferenceRegister = FirebaseDatabase.instance.ref('ECommerce App Admin Register').child(user.uId);
    databaseReferenceRegister = FirebaseDatabase.instance.ref('Uber App User Register').child(user.uId);
    DatabaseReference databaseReferenceLogin;
    //databaseReferenceLogin = FirebaseDatabase.instance.ref('ECommerce App Admin Login').child(deviceData3);
    databaseReferenceLogin = FirebaseDatabase.instance.ref('Uber App User Login').child(deviceData3);

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
    databaseReference.child("email").set(user.email); //aa@aa.com
    //databaseReference.child("password").set(password); //1111
    databaseReference.child("password").set(passwordSp); //1111
    databaseReferenceLogin.child("userName").set(user.username); //1111
    databaseReference.child("phoneNumber").set(user.phone); //1111
    databaseReference.child("profilePicture").set(user.userImg); //1111
    databaseReference.child("id").set(user.uId); //1111
    databaseReference.child("userJson").set(user.toMap()); //1111
    //(user.id).set(user.toJson())

    //todo For save user data in firebase realtime database end
  }


}