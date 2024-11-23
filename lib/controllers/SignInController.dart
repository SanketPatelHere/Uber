
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../logging/logger_helper.dart';
import '../utils/TLoaders.dart';



import 'GoogleSignInController.dart';

class SignInController extends GetxController {
  final TAG = "Myy SignInController ";

  ///static SignInController get instance => Get.find();

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    //for passwiord visibility
    static var isPasswordVisible = true.obs;

    Future<UserCredential?> signInMethod(String userEmail, String userPassword) async{
      try{
        TLoggerHelper.info("${TAG} inside signInMethod");
        EasyLoading.show(status: "Please wait...");
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: userEmail, password: userPassword);
        
        //for save data in realtime database
        GoogleSignInController.saveLoginInFirebase(userEmail, userPassword);

          EasyLoading.dismiss();
          return userCredential; //return to check user is verify or not(verify by click on email verify)

      }
      on FirebaseAuthException catch(e){
        TLoaders.errorSnakeBar(title: "Error in signInMethod  FirebaseAuthException ", message: "Something went wrong: "+e.toString());
        EasyLoading.dismiss();
        return null;
      }
      catch(e){
        TLoaders.errorSnakeBar(title: "Error in signInMethod catch ", message: "Something went wrong: "+e.toString());
        return null;
      }
    }




}