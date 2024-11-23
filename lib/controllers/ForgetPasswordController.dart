
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../logging/logger_helper.dart';
import '../screens/auth-ui/SignInScreen.dart';
import '../utils/TLoaders.dart';

class ForgetPasswordController extends GetxController {
  final TAG = "Myy ForgetPasswordController ";

  ///static ForgetPasswordController get instance => Get.find();

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;


    Future<UserCredential?> forgetPasswordMethod(String userEmail,) async{
      try{
          TLoggerHelper.info("${TAG} inside forgetPasswordMethod");
          EasyLoading.show(status: "Please wait...");
          await _auth.sendPasswordResetEmail(email: userEmail);
          TLoaders.successSnakeBar(title: "Request Sent Successfully", message: "Password reset link sent to "+userEmail);
          Get.offAll(()=>SignInScreen());
          EasyLoading.dismiss();
      }
      on FirebaseAuthException catch(e){
        TLoaders.errorSnakeBar(title: "Error in forgetPasswordMethod  FirebaseAuthException ", message: "Something went wrong: "+e.toString());
        EasyLoading.dismiss();
        return null;
      }
      catch(e){
        TLoaders.errorSnakeBar(title: "Error in forgetPasswordMethod catch ", message: "Something went wrong: "+e.toString());
        return null;
      }
      return null;
    }




}