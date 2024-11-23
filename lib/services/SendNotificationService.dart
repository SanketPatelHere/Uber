

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import '../logging/logger_helper.dart';
import '../screens/widget/CartScreen.dart';
import '../utils/TLoaders.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:app_settings/app_settings.dart';

import 'GetDeviceTokenController.dart';
import 'getserverkey.dart';



class SendNotificationService {
  static final TAG = "Myy SendNotificationService ";
  static final GetDeviceTokenController getDeviceTokenController = Get.put(GetDeviceTokenController());


  //for send notificaton to admin, when order is complete
  //for get admin token
  static Future<String?> getAdminToken() async{
    try{
      final querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("isAdmin", isEqualTo: true)
          .get();

      if(querySnapshot.docs.isNotEmpty){
        return  querySnapshot.docs.first["userDeviceToken"] as String;
      }
    }
    catch(e){
      TLoggerHelper.info("${TAG} getAdminToken Error in catch  e = "+e.toString());
      return "";
    }
  }

  static Future<void> sendNotificationUsingApi({
    required String? token,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,
  }) async {

    String serverKey = await GetServerKey().getServerKeyToken();
    TLoggerHelper.info("${TAG} notification serverKey = "+serverKey);
    var token1 = await getDeviceTokenController.deviceToken.toString();
    TLoggerHelper.info("${TAG} notification token = "+token.toString()); //get from arrive screen
    TLoggerHelper.info("${TAG} notification token1 = "+token1.toString()); //get from this screen

    final url = 'https://fcm.googleapis.com/fcm/send';
    //String url = "https://fcm.googleapis.com/v1/projects/ecomm-18247/messages-send";
    var headers = <String, String>{
      "Content-Type": "application/json",
      "Authorization": "Bearer $serverKey"

      //'content-type': 'application/json',
      //"Authorization": "Key=$serverKey"
    };
    TLoggerHelper.info("${TAG} notification headers = "+headers.toString());

/*
    Map<String, dynamic> message = {
        "message":{
          //"token":"eRcZ0IfWRMGC4MYXuOk1Dj:APA91bFLkxrqMlSQCozFvZMrLvqsIZguwwCWet4Bmc-jQOvwrx_gddH2ujk2VeoB8_GCDfxwR3Am6JL6c185H6NC7qavKTno3hv_RzvlWTKcskDZZp_sC6TdGjYPkjG4fH0svS2aIjCS",
          "token": token,
          "notification":{
            "title":"FCM Message",
            "body":"This is test message"
          }
         *//*,"data" : {
            "screen" : data
          }*//*
        }
      };*/


    String? adminToken = await getAdminToken();
    TLoggerHelper.info("${TAG} notification adminToken = "+adminToken.toString());

    //dynamic message(topic=all users, groupwise, token=specific users)
    Map<String, dynamic> message = {
      "message": {
        //"token": token, //or user itself
        //"token": token1, //or user itself
        //"token": adminToken, //or user to admin
        "topic": "all", //for send push notification to all users(group wise send)
        "notification": {
          "title": title,
          "body": body
        },
        ///"data": data
      }
    };

    // {message: {token: fPmaGgggSoqyHXnQ8sASEQ:APA91bHMt-L48LOV4ybFiWa2tQDegyfqEJ9eCj4CJucESyEHuNtmR8AxCL8bkCUalEs68QzUbKoXRH7nEp-KsVTlO8iGqYfA86YfJQ8ptxGM4QKTf4nJ2Jlx4c_7Rr9A3wvGHnQ1_NVJ, notification: {title: Order successfully placed, body: notification body}, data: {screen: notification}}}
    TLoggerHelper.info("${TAG} notification message = "+message.toString());

      //hit api
      final http.Response response1 = await http.post(
          Uri.parse(url),
          headers: headers,
          encoding: Encoding.getByName('utf-8'),
          body: jsonEncode(message)
      );

      //404
    TLoggerHelper.info("${TAG} notification response1.statusCode = "+response1.statusCode.toString());
    TLoggerHelper.info("${TAG} notification response1 = "+response1.toString());

      if(response1.statusCode==1){
        TLoggerHelper.info("${TAG} notification sent successfully");
      }
      else{
        TLoggerHelper.info("${TAG} notification not sent successfully");
      }
    }



}



/*
//working
{
  "message":{
    "token":"fPmaGgggSoqyHXnQ8sASEQ:APA91bHMt-L48LOV4ybFiWa2tQDegyfqEJ9eCj4CJucESyEHuNtmR8AxCL8bkCUalEs68QzUbKoXRH7nEp-KsVTlO8iGqYfA86YfJQ8ptxGM4QKTf4nJ2Jlx4c_7Rr9A3wvGHnQ1_NVJ",

    "notification":{
      "title":"FCM Message",
      "body":"This is test message"
    },
      "data" : {
      "screen" : "notification"
    }
    }
}

 */