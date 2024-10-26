
import 'package:get/get.dart';

import '../utils/TLoaders.dart';

import 'package:firebase_messaging/firebase_messaging.dart';



//GetDeviceTokenController same as getCustomerDeviceToken
class GetDeviceTokenController extends GetxController {
  final TAG = "Myy GetDeviceTokenController ";

  ///static GetDeviceTokenController get instance => Get.find();
  String? deviceToken;

  @override
  void onInit() {
    super.onInit();
    getDeviceToken();
  }

  Future<void> getDeviceToken() async {
      try{
          String? token = await FirebaseMessaging.instance.getToken();
          if(token!=null){
            deviceToken = token;
            update(); //The update will only notify the Widgets, if [condition] is true.
          }
      }
      catch(e){
        TLoaders.errorSnakeBar(title: "Error in forgetPasswordMethod catch ", message: "Something went wrong: "+e.toString());
      }
  }
  
  


}