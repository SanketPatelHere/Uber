

import '../logging/logger_helper.dart';

import 'package:firebase_messaging/firebase_messaging.dart';


//GetDeviceTokenController same as getCustomerDeviceToken
//same as GetDeviceTokenController
Future<String> getCustomerDeviceToken() async{
  final TAG = "Myy getCustomerDeviceToken ";

      try
      {
            String? token = await FirebaseMessaging.instance.getToken();
            if(token!=null)
            {
                return token;
            }
            else
            {
                throw Exception("Error in token");
            }
      }
      catch(e)
      {
        TLoggerHelper.info("${TAG} getCustomerDeviceToken  Error in catch e = "+e.toString());
        throw Exception("Error in token");
      }
}