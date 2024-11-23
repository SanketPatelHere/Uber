

import '../logging/logger_helper.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

//for get firebase fcm message
class FcmService {

  static void firebaseInit(){
      final TAG = "Myy FcmService ";
      FirebaseMessaging.onMessage.listen((message){
              TLoggerHelper.info("${TAG} notification = "+message.notification.toString());
              TLoggerHelper.info("${TAG} notification title = "+message.notification!.title.toString());
              TLoggerHelper.info("${TAG} notification body =  "+message.notification!.body.toString());

          }
      );
  }
}