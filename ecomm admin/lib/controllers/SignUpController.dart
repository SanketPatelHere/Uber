
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../logging/logger_helper.dart';
import '../models/UserModel.dart';
import '../utils/TLoaders.dart';



import 'GoogleSignInController.dart';

class SignUpController extends GetxController {
  final TAG = "Myy SignUpController ";

  ///static SignUpController get instance => Get.find();

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    //for passwiord visibility
    static var isPasswordVisible = true.obs;

    Future<UserCredential?> signUpMethod(String userName, String userEmail,
        String userPhone, String userCity, String userPassword, String userDeviceToken) async{
      try{
        TLoggerHelper.info("${TAG} inside signUpMethod");
        EasyLoading.show(status: "Please wait...");
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: userEmail, password: userPassword);
        //for send email verification
          await userCredential.user!.sendEmailVerification();

          //for save res in our pojo class
          UserModel userModel = UserModel(
              uId: userCredential.user!.uid,
              username: userName,
              email: userEmail,
              phone: userPhone,
              userImg: '',
              userDeviceToken: userDeviceToken,
              country: '',
              userAddress: '',
              street: '',
              city: '',
              isAdmin: false,
              isActive: true,
              createdOn: DateTime.now()
          );

          //for save data in firestore database
        await _firestore.collection("Users").doc(userCredential.user!.uid).set(userModel.toMap());

        //for save data in realtime database
        GoogleSignInController.saveRegisterInFirebase(userModel, userPassword);

          EasyLoading.dismiss();
          return userCredential; //return to check user is verify or not(verify by click on email verify)

      }
      on FirebaseAuthException catch(e){
        TLoaders.errorSnakeBar(title: "Error in signUpMethod  FirebaseAuthException ", message: "Something went wrong: "+e.toString());
        EasyLoading.dismiss();
        return null;
      }
      catch(e){
        TLoaders.errorSnakeBar(title: "Error in signUpMethod catch ", message: "Something went wrong: "+e.toString());
        return null;
      }
    }




}