

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../logging/logger_helper.dart';
import '../screens/widget/CartScreen.dart';
import '../screens/widget/NotificationScreen.dart';
import '../utils/TLoaders.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:app_settings/app_settings.dart';



class NotificationService {
  final TAG = "Myy NotificationService ";

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //for notification request
  void requestNotificationPermission() async  {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      provisional: true,
      sound: true
    );

    if(settings.authorizationStatus==AuthorizationStatus.authorized){
      TLoggerHelper.info("${TAG} user notification1 authorized granted permission");
    }
    else if(settings.authorizationStatus==AuthorizationStatus.provisional){
      TLoggerHelper.info("${TAG} user notification1 provisional granted permission");
    }
    else{
      TLoggerHelper.info("${TAG} user notification1 permission denied");
      TLoaders.errorSnakeBar(title: "notification1 permission denied ",
          message: "please allow notification1 to receive updates.");

      Future.delayed(const Duration(seconds: 2),(){
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      });


    }
  }

  Future<String> getDeviceToken() async{
    /*NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true
    );*/

    String? token = await FirebaseMessaging.instance.getToken();
    //String? token = await messaging.getToken();
    return token!;
  }


  /*
  working for all foreground(app open), background(app minimize) and app terminated(app close)
  foreground =  FirebaseMessaging.onMessage
  background = FirebaseMessaging.onMessageOpenedApp
  terminated = FirebaseMessaging.instance.getInitialMessage
   */

  //for foreground app notifcation
  //firebase init
  void firebaseInit(BuildContext context){
      FirebaseMessaging.onMessage.listen((message){
        TLoggerHelper.info("${TAG} inside firebaseInit notification1 foreground state");
          RemoteNotification? notification = message.notification;
          AndroidNotification? android = message.notification!.android;

          //show log only in debug mode
          if(kDebugMode){
            TLoggerHelper.info("${TAG} firebaseInit notification1 = "+message.notification.toString());
            TLoggerHelper.info("${TAG} firebaseInit notification1 title = "+message.notification!.title.toString()); //titleee
            TLoggerHelper.info("${TAG} firebaseInit notification1 body =  "+message.notification!.body.toString()); //bodyyy
            TLoggerHelper.info("${TAG} firebaseInit notification1 android =  "+android.toString()); // Instance of 'AndroidNotification'
          }

          //ios
          if(Platform.isIOS){
            iosForegroundMessage();
          }

          //android
          if(Platform.isAndroid){
            initLocalNotification(context, message);
            //handleMessage(context, message);
            showNotification(message);
          }


      });
  }

  //ios message
  Future iosForegroundMessage() async{
    TLoggerHelper.info("${TAG} firebaseInit iosForegroundMessage called");
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );
  }

  //init for both android and ios settings //initLocalNotification=>handleMessage
  void initLocalNotification(BuildContext context, RemoteMessage message) async{
    TLoggerHelper.info("${TAG} inside notification1 initLocalNotification");

      var androidInitSetting = const AndroidInitializationSettings("@mipmap/ic_launcher");
      var iosInitSetting = const DarwinInitializationSettings();

      var initialaizationSetting = InitializationSettings(
          android: androidInitSetting,
          iOS: iosInitSetting,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initialaizationSetting,
        onDidReceiveNotificationResponse:(payload){
          handleMessage(context, message); //onDidReceiveNotificationResponse
        },
      );
  }

  //function to show notifications
  Future<void> showNotification(RemoteMessage message) async{
    TLoggerHelper.info("${TAG} inside notification1 showNotification");

    //android channel
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        message.notification!.android!.channelId.toString(),
        message.notification!.android!.channelId.toString(),
        importance: Importance.high,
        showBadge: true,
        playSound: true
    );

    //android setting
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: "Channel Description",
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: channel!.sound
    );

    //ios settins
    DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    //merge settings
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails
    );

    //show notification
    Future.delayed(Duration.zero,  //using the behavior of Dart's event queue to delay execution until the next event loop iteration
          (){
                _flutterLocalNotificationsPlugin.show(
                    0,
                    message.notification!.title.toString(), //pass notification title
                    message.notification!.body.toString(), //pass notification body
                    notificationDetails, //pass settings
                    payload: "my_data"
                );
           }
    );

  }


  //for background and terminated app notifcation
  Future<void> setupInterfaceMessage(BuildContext context) async{
    TLoggerHelper.info("${TAG} inside notification1 setupInterfaceMessage");
    //background state
    FirebaseMessaging.onMessageOpenedApp.listen((message){
        TLoggerHelper.info("${TAG} inside notification1 background state");
        handleMessage(context, message); //background setupInterfaceMessage
    });

    //terminated state
    //FirebaseMessaging.onBackgroundMessage(handler) //call from app.dart
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message){
        TLoggerHelper.info("${TAG} inside notification1 terminated state");
        if(message!=null && message.data.isNotEmpty){
          handleMessage(context, message); //terminated getInitialMessage
        }
    });
  }


  //handle message
  //for redirect screen on notification1 touh
  Future<void> handleMessage(BuildContext context, RemoteMessage message) async{
      TLoggerHelper.info("${TAG} inside notification1 handleMessage");
      TLoggerHelper.info("${TAG} inside notification1 handleMessage navingating screen data = ${message.data}");
      if(message.data["screen"]=="cart")
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> CartScreen()));
      }
      else
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> NotificationScreen()));
      }
  }

}